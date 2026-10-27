#!/bin/bash

'''
Setup script for Terra RStudio environment with dbt pipeline.
Requires R 4.5.1, Bioconductor 3.21, and Python 3.12.3.

Requirements are satisfied for:
Developing and running dbt pipelines
"AnVIL-DD-Extract" - Pull data from DUOS and TDR apis
'''

set -euo pipefail

# 1. Update system packages
sudo apt-get update

# Terminal installs for pipeline, in a venv (Ubuntu 24.04 blocks system-wide pip installs)
VENV_DIR=/home/rstudio/venv-dbt
python3.12 -m venv "$VENV_DIR"
"$VENV_DIR/bin/pip" install --upgrade pip

# Match Python DuckDB to the R duckdb package version so both can open the
# same database files. Keep these pins together to prevent pip from upgrading
# DuckDB to a newer storage format through dbt-duckdb's dependency.
"$VENV_DIR/bin/pip" install \
  dbt-core==1.12.5 \
  dbt-duckdb==1.11.0 \
  requests==2.34.2 \
  pandas==2.2.3 \
  openpyxl==3.1.5 \
  beautifulsoup4==4.15.0 \
  lxml==6.1.3

"$VENV_DIR/bin/python" -c \
  'import duckdb; print(f"Python DuckDB version: {duckdb.__version__}")'

echo "dbt installed in $VENV_DIR - activate with: source $VENV_DIR/bin/activate"
