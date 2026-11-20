-- Which datasets populate which columns. Change the table or options below.
-- measure: 'any' (1/0), 'count' or 'proportion'. See analysis/README.md.
{{ profile_column_presence(
    ref('cmg_main_subject'),
    group_by='ingest_provenance',
    except=['datarepo_row_id'],
    measure='any',
    blank_as_null=false
) }}
