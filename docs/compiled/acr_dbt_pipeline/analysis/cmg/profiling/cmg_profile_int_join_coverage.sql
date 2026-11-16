-- Checks every join the cmg int models make: does a left join drop or duplicate rows?
-- rows_added_by_join > 0 means duplicates; left_rows_unmatched > 0 means rows with no match.
-- See analysis/README.md.
select * from (
with l as (
  select
    "source_snapshot_id" as k_1,
    count(*) as n_left
  from "acr_dbt_pipeline"."main_cmg"."cmg_main_subject"
  group by all
),
r as (
  select
    "source_snapshot_id" as k_1,
    count(*) as n_right
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_anvil_dataset"
  group by all
),
keys as (
  select
    l.n_left,
    r.n_right,
    l.k_1 is null as left_key_has_null
  from l
  full outer join r
    on l.k_1 = r.k_1
)
select
  'subject -> anvil_dataset' as check_name,
  coalesce(sum(n_left), 0) as left_rows,
  count(n_left) as left_keys,
  count(n_left) filter (where n_right is not null) as left_keys_matched,
  coalesce(sum(n_left) filter (where n_right is null), 0) as left_rows_unmatched,
  coalesce(sum(n_left) filter (where n_right is null and left_key_has_null), 0) as left_rows_null_key,
  count(n_right) as right_keys,
  count(n_right) filter (where n_left is null) as right_keys_unmatched,
  max(n_left) as max_left_rows_per_key,
  coalesce(max(n_right) filter (where n_left is not null), 0) as max_right_rows_per_key,
  coalesce(sum(n_left * coalesce(n_right, 1)) filter (where n_left is not null), 0) as rows_after_left_join,
  coalesce(sum(n_left * coalesce(n_right, 1)) filter (where n_left is not null), 0)
    - coalesce(sum(n_left), 0) as rows_added_by_join
from keys
)
union all
select * from (
with l as (
  select
    "source_snapshot_id" as k_1,
    count(*) as n_left
  from "acr_dbt_pipeline"."main_cmg"."cmg_main_family"
  group by all
),
r as (
  select
    "source_snapshot_id" as k_1,
    count(*) as n_right
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_anvil_dataset"
  group by all
),
keys as (
  select
    l.n_left,
    r.n_right,
    l.k_1 is null as left_key_has_null
  from l
  full outer join r
    on l.k_1 = r.k_1
)
select
  'family -> anvil_dataset' as check_name,
  coalesce(sum(n_left), 0) as left_rows,
  count(n_left) as left_keys,
  count(n_left) filter (where n_right is not null) as left_keys_matched,
  coalesce(sum(n_left) filter (where n_right is null), 0) as left_rows_unmatched,
  coalesce(sum(n_left) filter (where n_right is null and left_key_has_null), 0) as left_rows_null_key,
  count(n_right) as right_keys,
  count(n_right) filter (where n_left is null) as right_keys_unmatched,
  max(n_left) as max_left_rows_per_key,
  coalesce(max(n_right) filter (where n_left is not null), 0) as max_right_rows_per_key,
  coalesce(sum(n_left * coalesce(n_right, 1)) filter (where n_left is not null), 0) as rows_after_left_join,
  coalesce(sum(n_left * coalesce(n_right, 1)) filter (where n_left is not null), 0)
    - coalesce(sum(n_left), 0) as rows_added_by_join
from keys
)
union all
select * from (
with l as (
  select
    "subject_id" as k_1,
    "source_snapshot_id" as k_2,
    count(*) as n_left
  from "acr_dbt_pipeline"."main_cmg"."cmg_main_sample"
  group by all
),
r as (
  select
    "subject_id" as k_1,
    "source_snapshot_id" as k_2,
    count(*) as n_right
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject"
  group by all
),
keys as (
  select
    l.n_left,
    r.n_right,
    l.k_1 is null or
    l.k_2 is null as left_key_has_null
  from l
  full outer join r
    on l.k_1 = r.k_1 and l.k_2 = r.k_2
)
select
  'sample -> subject' as check_name,
  coalesce(sum(n_left), 0) as left_rows,
  count(n_left) as left_keys,
  count(n_left) filter (where n_right is not null) as left_keys_matched,
  coalesce(sum(n_left) filter (where n_right is null), 0) as left_rows_unmatched,
  coalesce(sum(n_left) filter (where n_right is null and left_key_has_null), 0) as left_rows_null_key,
  count(n_right) as right_keys,
  count(n_right) filter (where n_left is null) as right_keys_unmatched,
  max(n_left) as max_left_rows_per_key,
  coalesce(max(n_right) filter (where n_left is not null), 0) as max_right_rows_per_key,
  coalesce(sum(n_left * coalesce(n_right, 1)) filter (where n_left is not null), 0) as rows_after_left_join,
  coalesce(sum(n_left * coalesce(n_right, 1)) filter (where n_left is not null), 0)
    - coalesce(sum(n_left), 0) as rows_added_by_join
from keys
)
union all
select * from (
with l as (
  select
    "sample_id" as k_1,
    "source_snapshot_id" as k_2,
    count(*) as n_left
  from "acr_dbt_pipeline"."main_cmg"."cmg_main_sequencing"
  group by all
),
r as (
  select
    "sample_id" as k_1,
    "source_snapshot_id" as k_2,
    count(*) as n_right
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_sample"
  group by all
),
keys as (
  select
    l.n_left,
    r.n_right,
    l.k_1 is null or
    l.k_2 is null as left_key_has_null
  from l
  full outer join r
    on l.k_1 = r.k_1 and l.k_2 = r.k_2
)
select
  'sequencing -> sample' as check_name,
  coalesce(sum(n_left), 0) as left_rows,
  count(n_left) as left_keys,
  count(n_left) filter (where n_right is not null) as left_keys_matched,
  coalesce(sum(n_left) filter (where n_right is null), 0) as left_rows_unmatched,
  coalesce(sum(n_left) filter (where n_right is null and left_key_has_null), 0) as left_rows_null_key,
  count(n_right) as right_keys,
  count(n_right) filter (where n_left is null) as right_keys_unmatched,
  max(n_left) as max_left_rows_per_key,
  coalesce(max(n_right) filter (where n_left is not null), 0) as max_right_rows_per_key,
  coalesce(sum(n_left * coalesce(n_right, 1)) filter (where n_left is not null), 0) as rows_after_left_join,
  coalesce(sum(n_left * coalesce(n_right, 1)) filter (where n_left is not null), 0)
    - coalesce(sum(n_left), 0) as rows_added_by_join
from keys
)
union all
select * from (
with l as (
  select
    "file_ref" as k_1,
    "source_snapshot_id" as k_2,
    count(*) as n_left
  from "acr_dbt_pipeline"."main_cmg"."cmg_main_file_inventory"
  group by all
),
r as (
  select
    "sequencing_id_fileref" as k_1,
    "source_snapshot_id" as k_2,
    count(*) as n_right
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_sequencing"
  group by all
),
keys as (
  select
    l.n_left,
    r.n_right,
    l.k_1 is null or
    l.k_2 is null as left_key_has_null
  from l
  full outer join r
    on l.k_1 = r.k_1 and l.k_2 = r.k_2
)
select
  'file_inventory -> sequencing (sequencing_id_fileref)' as check_name,
  coalesce(sum(n_left), 0) as left_rows,
  count(n_left) as left_keys,
  count(n_left) filter (where n_right is not null) as left_keys_matched,
  coalesce(sum(n_left) filter (where n_right is null), 0) as left_rows_unmatched,
  coalesce(sum(n_left) filter (where n_right is null and left_key_has_null), 0) as left_rows_null_key,
  count(n_right) as right_keys,
  count(n_right) filter (where n_left is null) as right_keys_unmatched,
  max(n_left) as max_left_rows_per_key,
  coalesce(max(n_right) filter (where n_left is not null), 0) as max_right_rows_per_key,
  coalesce(sum(n_left * coalesce(n_right, 1)) filter (where n_left is not null), 0) as rows_after_left_join,
  coalesce(sum(n_left * coalesce(n_right, 1)) filter (where n_left is not null), 0)
    - coalesce(sum(n_left), 0) as rows_added_by_join
from keys
)
union all
select * from (
with l as (
  select
    "file_ref" as k_1,
    "source_snapshot_id" as k_2,
    count(*) as n_left
  from "acr_dbt_pipeline"."main_cmg"."cmg_main_file_inventory"
  group by all
),
r as (
  select
    "seq_filename" as k_1,
    "source_snapshot_id" as k_2,
    count(*) as n_right
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_sequencing"
  group by all
),
keys as (
  select
    l.n_left,
    r.n_right,
    l.k_1 is null or
    l.k_2 is null as left_key_has_null
  from l
  full outer join r
    on l.k_1 = r.k_1 and l.k_2 = r.k_2
)
select
  'file_inventory -> sequencing (seq_filename)' as check_name,
  coalesce(sum(n_left), 0) as left_rows,
  count(n_left) as left_keys,
  count(n_left) filter (where n_right is not null) as left_keys_matched,
  coalesce(sum(n_left) filter (where n_right is null), 0) as left_rows_unmatched,
  coalesce(sum(n_left) filter (where n_right is null and left_key_has_null), 0) as left_rows_null_key,
  count(n_right) as right_keys,
  count(n_right) filter (where n_left is null) as right_keys_unmatched,
  max(n_left) as max_left_rows_per_key,
  coalesce(max(n_right) filter (where n_left is not null), 0) as max_right_rows_per_key,
  coalesce(sum(n_left * coalesce(n_right, 1)) filter (where n_left is not null), 0) as rows_after_left_join,
  coalesce(sum(n_left * coalesce(n_right, 1)) filter (where n_left is not null), 0)
    - coalesce(sum(n_left), 0) as rows_added_by_join
from keys
)