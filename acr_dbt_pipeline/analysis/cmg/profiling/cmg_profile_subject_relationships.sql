-- 1:1 / 1:N / N:1 / N:N between every pair of the listed columns.
-- Keep the list short: the number of pairs grows with the square of the list. See analysis/README.md.
{{ profile_column_relationships(
    ref('cmg_main_subject'),
    columns=[
      'subject_id', 'family_id', 'maternal_id', 'paternal_id',
      'proband_relationship', 'affected_status', 'sex', 'project_id'
    ],
    group_by=none
) }}
