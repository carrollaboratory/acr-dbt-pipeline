-- Distinct non-null values per column across all datasets.
-- Set group_by='source_snapshot' to get one row per dataset. See analysis/README.md.
{{ profile_distinct_counts(
    ref('cmg_main_subject'),
    group_by=none,
    except=['datarepo_row_id']
) }}
