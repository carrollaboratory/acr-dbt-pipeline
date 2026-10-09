#!/bin/bash
set -euo pipefail

# 1. Update system packages
sudo apt-get update

# Terminal installs for pipeline, in a venv (Ubuntu 24.04 blocks system-wide pip installs)
VENV_DIR=/home/rstudio/venv-dbt
python3.12 -m venv "$VENV_DIR"
"$VENV_DIR/bin/pip" install --upgrade pip
"$VENV_DIR/bin/pip" install dbt-core
"$VENV_DIR/bin/pip" install dbt-duckdb
"$VENV_DIR/bin/pip" install dbt-bigquery


echo "dbt installed in $VENV_DIR - activate with: source $VENV_DIR/bin/activate"