-- Drill-down for one pair from cmg_profile_subject_relationships:
-- lists the values that break a 1:1 mapping. Empty result = 1:1. See analysis/README.md.
{{ profile_column_pair(
    ref('cmg_main_subject'),
    column_a='subject_id',
    column_b='family_id',
    group_by='source_snapshot'
) }}
