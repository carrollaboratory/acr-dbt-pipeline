# macros

## generate_global_id

    This macro generates the sql required to create a primary or foreign key
    by the md5 on a composite string method.

    Example usage - lacking double brackets:
        generate_md5_composite_key("p", ['id','dob'])
    generates the following sql
        'p' || '_' || md5(studyid || CAST(coalesce(id, '') AS TEXT) || '|' || CAST(coalesce(dob, '') AS TEXT))
    results in an id with the following format
        p_a32b29ffb1a85590c4a6d4cbeec18636


## get_columns

    This macro generates a list of column names from the table(reference) specified
    in the argument `from`. The list will exclude columns listed in the argument `except`.

    Example usage, ignore the variable names, this is more specific:
    {% set relation = ref('{study}_stg_{table}') %}
    {% set constant_columns = ['subject_id'] %}
    {% set condition_columns = get_columns(relation=relation, exclude=constant_columns) %}

    The macro generates the following list
        ['subject_id','other_col_1', 'other_col_2',...]

## normalize_parquet_columns

    Builds the src-layer select list for a Parquet file glob. It introspects the
    file with `describe select * from read_parquet(...)` and emits:

    - one `acr_clean_text(COLUMNS([...]))` expression covering every VARCHAR
      column, so the compiled SQL does not grow with column count
    - one `COLUMNS([...])` expression passing every non-VARCHAR column through
      untouched, so no varchar round-trip is introduced and the stored Parquet
      value and type are carried through unchanged
    - explicit `expr as "name"` entries only for columns that need renaming

    Applying a function to a `COLUMNS` expression keeps each column's original
    name, so the first two forms need no alias.

    Pass `rename_map` to map a lowercased source name to a different output name.

## create_text_cleaner / text_cleaner_name

    `create_text_cleaner()` returns DDL that installs the `acr_clean_text(v)`
    macro into the DuckDB database. It is run by the `on-run-start` hook in
    dbt_project.yml, so the cleaning rule is defined once instead of being
    repeated for every column of every model.

    `acr_clean_text` trims a text value and returns NULL when the trimmed,
    lowercased result is empty or matches `vars.source_null_sentinels`.

## sql_name_list

    Converts a list of column names into a DuckDB list literal for use inside a
    `COLUMNS([...])` expression.
