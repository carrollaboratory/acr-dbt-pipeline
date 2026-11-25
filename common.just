# Shared generator function recipes.
# These expect environment variables to be set by the calling justfile.

_dd_source_args := '
    args=()
    if [[ -n "${DD_DIR:-}" ]]; then args+=(-i "$DD_DIR"); fi
    for entry in ${RELEASE_ASSETS:-}; do
        repo="${entry%%|*}"
        asset="${entry#*|}"
        args+=(--release "$repo" "$asset")
    done
    if [[ -n "${RELEASE_TAG:-}" ]]; then args+=(--release-tag "$RELEASE_TAG"); fi
    if [[ -n "${RELEASE_TOKEN:-}" ]]; then args+=(--release-token "$RELEASE_TOKEN"); fi
    if [[ -n "${REFRESH:-}" ]]; then args+=(--refresh); fi
'

_sqlfluff_generated_models := '
    sqlfluff fix --config lint/.sqlfluff --templater jinja --disable-progress-bar "${files[@]}"
    sqlfluff lint --config lint/.sqlfluff --templater jinja --disable-progress-bar "${files[@]}"
'

[private]
_gen_models:
    #!/usr/bin/env bash
    {{ _dd_source_args }}
    args+=(-o "$MODELS_YML" -f "$DD_FORMAT")
    if [[ -n "${TABLE_PREFIX:-}" ]]; then args+=(-p "$TABLE_PREFIX"); fi
    if [[ -n "${MODELS_DOCS:-}" ]]; then args+=(-d "$MODELS_DOCS"); fi
    if [[ -n "${VERSION_LOG:-}" ]]; then args+=(--version-log "$VERSION_LOG"); fi
    if [[ "${NORMALIZE_MODEL_COLUMNS:-false}" == "true" ]]; then args+=(--normalize-column-names); fi
    generate_models_yml "${args[@]}"

[private]
_gen_sources:
    #!/usr/bin/env bash
    {{ _dd_source_args }}
    args+=(-o "$SOURCES_YML" -s "$SOURCE_NAME" --schema "$SOURCE_SCHEMA" -f "$DD_FORMAT")
    if [[ -n "${TABLE_PREFIX:-}" ]]; then args+=(-p "$TABLE_PREFIX"); fi
    if [[ -n "${SOURCES_DOCS:-}" ]]; then args+=(-d "$SOURCES_DOCS"); fi
    if [[ -n "${VERSION_LOG:-}" ]]; then args+=(--version-log "$VERSION_LOG"); fi
    generate_sources_yml "${args[@]}"

[private]
_gen_model_sql:
    #!/usr/bin/env bash
    set -euo pipefail
    {{ _dd_source_args }}
    output_dir="$(mktemp -d)"
    trap 'rm -rf "$output_dir"' EXIT
    args+=(-o "$output_dir" -f "$DD_FORMAT")
    if [[ -n "${TABLE_PREFIX:-}" ]]; then args+=(-p "$TABLE_PREFIX"); fi
    if [[ -n "${PROGRAM_REF_PREFIX:-}" ]]; then
        args+=(--program-ref-prefix "$PROGRAM_REF_PREFIX")
    elif [[ -n "${FROM_CLAUSE_TEMPLATE:-}" ]]; then
        args+=(--from-clause-template "$FROM_CLAUSE_TEMPLATE")
    fi
    if [[ -n "${SQL_REFERENCE_DIR:-}" ]]; then args+=(--reference-dir "$SQL_REFERENCE_DIR"); fi
    if [[ -n "${VERSION_LOG:-}" ]]; then args+=(--version-log "$VERSION_LOG"); fi
    if [[ "${INT_DESCRIPTORS:-false}" == "true" ]]; then args+=(--int-descriptors); fi
    generate_sql_models "${args[@]}"
    if [[ "${EMPTY_MODEL_SCAFFOLD:-false}" == "true" ]]; then
        python scripts/stb_scaffolds.py "$output_dir"
    fi
    shopt -s nullglob
    files=("$output_dir"/*.sql)
    if (( ${#files[@]} )); then
        {{ _sqlfluff_generated_models }}
        mkdir -p "$SQL_DIR"
        cp "${files[@]}" "$SQL_DIR/"
    fi

[private]
_gen_stb_union_sql:
    #!/usr/bin/env bash
    set -euo pipefail
    {{ _dd_source_args }}
    output_dir="$(mktemp -d)"
    trap 'rm -rf "$output_dir"' EXIT
    args+=(-o "$output_dir" --studies-var "$STUDIES_VAR" --model-prefix "${TABLE_PREFIX:-}")
    generate_stb_union_sql "${args[@]}"
    shopt -s nullglob
    files=("$output_dir"/*.sql)
    if (( ${#files[@]} )); then
        {{ _sqlfluff_generated_models }}
        mkdir -p "$SQL_DIR"
        cp "${files[@]}" "$SQL_DIR/"
    fi

[private]
_gen_src_sql:
    #!/usr/bin/env bash
    set -euo pipefail
    {{ _dd_source_args }}
    if [[ -z "$SRC_SQL_DIR" ]]; then
        echo "Set SRC_SQL_DIR before generating SRC SQL." >&2
        exit 2
    fi
    output_dir="$(mktemp -d)"
    trap 'rm -rf "$output_dir"' EXIT
    args+=(-o "$output_dir" -s "$SRC_SOURCE_NAME" -f "$DD_FORMAT" --materialized "$SRC_MATERIALIZED")
    if [[ -n "${SRC_TABLE_PREFIX:-}" ]]; then args+=(--sql-file-prefix "$SRC_TABLE_PREFIX"); fi
    if [[ -n "${TABLE_PREFIX:-}" ]]; then args+=(-p "$TABLE_PREFIX"); fi
    if [[ -n "${VERSION_LOG:-}" ]]; then args+=(--version-log "$VERSION_LOG"); fi
    generate_src_models "${args[@]}"
    shopt -s nullglob
    files=("$output_dir"/*.sql)
    if (( ${#files[@]} == 0 )); then
        echo "No SRC SQL models were generated; check the DD inputs." >&2
        exit 2
    fi
    # Jinja rendering checks generated SQL without a database or dbt manifest.
    {{ _sqlfluff_generated_models }}
    mkdir -p "$SRC_SQL_DIR"
    cp "${files[@]}" "$SRC_SQL_DIR/"

[private]
_sync_model_enums:
    #!/usr/bin/env bash
    set -euo pipefail
    if [[ -z "${ENUMS_SEED_PATH:-}" ]]; then
        echo "Set ENUMS_SEED_PATH before syncing model enumerations." >&2
        exit 2
    fi
    release_assets="${RELEASE_ASSETS:-}"
    read -r -a releases <<< "${release_assets//$'\n'/ }"
    if (( ${#releases[@]} != 1 )); then
        echo "Enumeration seed extraction requires exactly one release for $ENUMS_SEED_PATH." >&2
        exit 2
    fi
    release="${releases[0]}"
    if [[ "$release" != *"|"* || -z "${release%%|*}" || -z "${release#*|}" || "${release#*|}" == *"|"* ]]; then
        echo "Invalid release asset '$release' (expected repo|asset)." >&2
        exit 2
    fi
    if [[ -d "$ENUMS_SEED_PATH" ]]; then
        echo "Enumeration seed destination is a directory: $ENUMS_SEED_PATH" >&2
        exit 2
    fi
    seed_dir="$(dirname "$ENUMS_SEED_PATH")"
    mkdir -p "$seed_dir"
    output_dir="$(mktemp -d "$seed_dir/.model-enums.XXXXXXXX")"
    trap 'rm -f -- "$output_dir/model_enums.tmp"; rmdir -- "$output_dir"' EXIT
    RELEASE_REPO="${release%%|*}" \
    RELEASE_ARTIFACT="${release#*|}" \
    RELEASE_INTERNAL_PATH="project/enumerations/model_enums.csv" \
    RELEASE_OUTPUT_PATH="$output_dir/model_enums.tmp" \
        just -f common.just _extract_release_file
    mv -f -- "$output_dir/model_enums.tmp" "$ENUMS_SEED_PATH"

[private]
_extract_release_file:
    #!/usr/bin/env bash
    if [[ -z "${RELEASE_REPO:-}" ]]; then
        echo "Set RELEASE_REPO to a preset (kf/include/inc/common) or a full GitHub URL." >&2
        exit 2
    fi
    if [[ -z "${RELEASE_INTERNAL_PATH:-}" ]]; then
        echo "Set RELEASE_INTERNAL_PATH to the file path inside $RELEASE_ARTIFACT." >&2
        exit 2
    fi
    if [[ -z "${RELEASE_OUTPUT_PATH:-}" ]]; then
        echo "Set RELEASE_OUTPUT_PATH to the destination file path." >&2
        exit 2
    fi

    args=(
      "$RELEASE_REPO"
      "$RELEASE_ARTIFACT"
      "$RELEASE_INTERNAL_PATH"
      "$RELEASE_OUTPUT_PATH"
      --tag "$RELEASE_TAG"
    )
    if [[ -n "${RELEASE_TOKEN:-}" ]]; then args+=(--token "$RELEASE_TOKEN"); fi
    if [[ -n "${REFRESH:-}" ]]; then args+=(--refresh); fi

    extract_release_artifact_file "${args[@]}"
