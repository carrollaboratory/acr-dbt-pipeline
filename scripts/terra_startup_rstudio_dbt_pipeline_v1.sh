#!/usr/bin/env bash
set -euo pipefail

PYTHON_BIN="${PYTHON_BIN:-python3.12}"
DBT_VENV_DIR="${DBT_VENV_DIR:-/home/rstudio/venv-dbt}"
RSTUDIO_HOME="${RSTUDIO_HOME:-/home/rstudio}"
ENV_FILE_LOCAL="${ACR_DBT_ENV_FILE:-${RSTUDIO_HOME}/.acr_dbt_pipeline.env}"
ENV_FILE_URI="${ACR_DBT_ENV_URI:-}"
BASHRC_PATH="${ACR_DBT_BASHRC:-${RSTUDIO_HOME}/.bashrc}"

if [[ -z "$ENV_FILE_URI" && -n "${WORKSPACE_BUCKET:-}" ]]; then
  ENV_FILE_URI="${WORKSPACE_BUCKET%/}/config/acr_dbt_pipeline.env"
fi

if [[ -z "$ENV_FILE_URI" ]]; then
  echo "WORKSPACE_BUCKET is unset and ACR_DBT_ENV_URI was not provided." >&2
  echo "Set ACR_DBT_ENV_URI to the gs:// path of acr_dbt_pipeline.env." >&2
  exit 1
fi

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "Required Python interpreter not found: $PYTHON_BIN" >&2
  exit 1
fi

download_env_file() {
  if command -v gcloud >/dev/null 2>&1; then
    gcloud storage cp "$1" "$2"
  elif command -v gsutil >/dev/null 2>&1; then
    gsutil cp "$1" "$2"
  else
    echo "Neither gcloud nor gsutil is available to fetch $1" >&2
    return 1
  fi
}

echo "Fetching pipeline configuration from $ENV_FILE_URI"
download_env_file "$ENV_FILE_URI" "$ENV_FILE_LOCAL"

set -a
# shellcheck source=/dev/null
source "$ENV_FILE_LOCAL"
set +a

ENV_SOURCE_LINE="[ -r \"$ENV_FILE_LOCAL\" ] && set -a && . \"$ENV_FILE_LOCAL\" && set +a"
if [[ ! -f "$BASHRC_PATH" ]] || ! grep -Fqx "$ENV_SOURCE_LINE" "$BASHRC_PATH"; then
  {
    printf '\n# acr-dbt-pipeline shared configuration\n'
    printf '%s\n' "$ENV_SOURCE_LINE"
  } >>"$BASHRC_PATH"
fi

"$PYTHON_BIN" -m venv "$DBT_VENV_DIR"
"$DBT_VENV_DIR/bin/pip" install --upgrade pip
"$DBT_VENV_DIR/bin/pip" install \
  "dbt-core==1.11.11" \
  "dbt-duckdb==1.11.0"

"$DBT_VENV_DIR/bin/dbt" --version

"$DBT_VENV_DIR/bin/python" - <<'PY'
import os
import re

import duckdb

project_pattern = re.compile(r"^[a-z][a-z0-9-]{4,28}[a-z0-9]$")
project_variable_pattern = re.compile(r"^TDR_(?P<name>[A-Z0-9_]+)_BQ_PROJECT$")

connection = duckdb.connect(":memory:")
connection.execute("INSTALL bigquery FROM community")
connection.execute("LOAD bigquery")

attached = 0
for variable, project in sorted(os.environ.items()):
    match = project_variable_pattern.match(variable)
    if not match or not project:
        continue
    if not project_pattern.fullmatch(project):
        raise ValueError(f"{variable} is not a valid GCP project ID: {project!r}")

    alias = f"{match.group('name').lower()}_bq"
    connection.execute(
        f"ATTACH 'project={project}' AS {alias} (TYPE bigquery, READ_ONLY)"
    )
    connection.execute(f"DETACH {alias}")
    print(f"Verified read-only BigQuery attach: {project} as {alias}")
    attached += 1

if attached == 0:
    raise SystemExit(
        "No TDR_*_BQ_PROJECT variables were set; check the workspace .env file"
    )

connection.close()
PY

echo "dbt installed in $DBT_VENV_DIR"
echo "Activate with: source $DBT_VENV_DIR/bin/activate"
echo "Shared configuration loaded from $ENV_FILE_LOCAL"
echo "New RStudio terminals load it from $BASHRC_PATH"
echo "For this terminal, run: source $ENV_FILE_LOCAL"
