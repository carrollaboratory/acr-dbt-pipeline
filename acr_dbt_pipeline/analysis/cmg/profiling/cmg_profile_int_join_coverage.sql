-- Checks every join the cmg int models make: does a left join drop or duplicate rows?
-- rows_added_by_join > 0 means duplicates; left_rows_unmatched > 0 means rows with no match.
-- See analysis/README.md.
{{ profile_join_coverage(
    ref('cmg_main_subject'), ref('cmg_int_anvil_dataset'),
    left_columns=['source_snapshot_id'],
    label='subject -> anvil_dataset'
) }}
union all
{{ profile_join_coverage(
    ref('cmg_main_family'), ref('cmg_int_anvil_dataset'),
    left_columns=['source_snapshot_id'],
    label='family -> anvil_dataset'
) }}
union all
{{ profile_join_coverage(
    ref('cmg_main_sample'), ref('cmg_int_subject'),
    left_columns=['subject_id', 'source_snapshot_id'],
    label='sample -> subject'
) }}
union all
{{ profile_join_coverage(
    ref('cmg_main_sequencing'), ref('cmg_int_sample'),
    left_columns=['sample_id', 'source_snapshot_id'],
    label='sequencing -> sample'
) }}
union all
{{ profile_join_coverage(
    ref('cmg_main_file_inventory'), ref('cmg_int_sequencing'),
    left_columns=['file_ref', 'source_snapshot_id'],
    right_columns=['sequencing_id_fileref', 'source_snapshot_id'],
    label='file_inventory -> sequencing (sequencing_id_fileref)'
) }}
union all
{{ profile_join_coverage(
    ref('cmg_main_file_inventory'), ref('cmg_int_sequencing'),
    left_columns=['file_ref', 'source_snapshot_id'],
    right_columns=['seq_filename', 'source_snapshot_id'],
    label='file_inventory -> sequencing (seq_filename)'
) }}
