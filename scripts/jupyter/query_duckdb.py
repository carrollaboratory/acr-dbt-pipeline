#!/usr/bin/env python
# ```
# Tool to query tables in the duckdb database.
# Create new cells for study specific analysis/validation.
# ```

import duckdb
import pandas as pd
import os

# Environment setup
if os.environ.get("WORKSPACE_BUCKET"):
    bucket = os.environ.get("WORKSPACE_BUCKET")
else:
    bucket = "bucket_placeholder"

engine = duckdb.connect("/tmp/dbt.duckdb")


def execute(query):
    """
    Connect to duckdb, execute a query and format as a DataFrame with headers.
    """
    result = engine.execute(query)
    df = pd.DataFrame(result.fetchall(), columns=[col[0] for col in result.description])
    return df


def convert_csv_to_utf8(input_file_path, output_filepath, delimiter, encoding):
    df = pd.read_csv(input_file_path, encoding=encoding, delimiter=delimiter, quoting=3)
    df.to_csv(output_filepath, index=False, encoding="utf-8")
    print(f"Converted CSV saved to {output_filepath}")


tables = engine.execute(
    "SELECT table_name FROM information_schema.tables WHERE table_schema = 'main_gregor_synthetic_data'"
).fetchall()
print(tables)

table = engine.execute(
    "PRAGMA table_info('main_gregor_synthetic_data.gregor_synthetic_ftd_demographics')"
).fetchall()
print(table)

d = engine.execute(
    "SELECT * FROM main_gregor_synthetic_data.gregor_synthetic_ftd_demographics LIMIT 10"
).fetchall()
print(f"FTD Demographics\n {d}\n")
