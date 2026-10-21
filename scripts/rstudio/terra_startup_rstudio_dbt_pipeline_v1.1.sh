#!/bin/bash
set -euo pipefail

# 1. Update system packages
sudo apt-get update

# Terminal installs for pipeline, in a venv (Ubuntu 24.04 blocks system-wide pip installs)
VENV_DIR=/home/rstudio/venv-dbt
python3.12 -m venv "$VENV_DIR"
"$VENV_DIR/bin/pip" install --upgrade pip
"$VENV_DIR/bin/pip" install dbt-core==1.12.5
"$VENV_DIR/bin/pip" install dbt-duckdb==1.11.0
"$VENV_DIR/bin/pip" install dbt-bigquery==1.12.1

echo "dbt installed in $VENV_DIR - activate with: source $VENV_DIR/bin/activate"