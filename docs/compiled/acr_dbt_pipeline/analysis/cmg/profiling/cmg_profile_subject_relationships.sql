-- 1:1 / 1:N / N:1 / N:N between every pair of the listed columns.
-- Keep the list short: the number of pairs grows with the square of the list. See analysis/README.md.
with counts as (
  select
    count(*) as n_rows,
    count(distinct md5(cast(coalesce(cast("subject_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_1,
    count(distinct md5(cast(coalesce(cast("affected_status" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_2,
    count(distinct md5(cast(coalesce(cast("family_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_3,
    count(distinct md5(cast(coalesce(cast("proband_relationship" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_4,
    count(distinct md5(cast(coalesce(cast("project_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_5,
    count(distinct md5(cast(coalesce(cast("sex" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_6,
    count(distinct md5(cast(coalesce(cast("maternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_7,
    count(distinct md5(cast(coalesce(cast("paternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_8,
    count(distinct md5(cast(coalesce(cast("subject_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("affected_status" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_1_2,
    count(distinct md5(cast(coalesce(cast("subject_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("family_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_1_3,
    count(distinct md5(cast(coalesce(cast("subject_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("proband_relationship" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_1_4,
    count(distinct md5(cast(coalesce(cast("subject_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("project_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_1_5,
    count(distinct md5(cast(coalesce(cast("subject_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("sex" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_1_6,
    count(distinct md5(cast(coalesce(cast("subject_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("maternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_1_7,
    count(distinct md5(cast(coalesce(cast("subject_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("paternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_1_8,
    count(distinct md5(cast(coalesce(cast("affected_status" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("family_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_2_3,
    count(distinct md5(cast(coalesce(cast("affected_status" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("proband_relationship" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_2_4,
    count(distinct md5(cast(coalesce(cast("affected_status" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("project_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_2_5,
    count(distinct md5(cast(coalesce(cast("affected_status" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("sex" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_2_6,
    count(distinct md5(cast(coalesce(cast("affected_status" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("maternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_2_7,
    count(distinct md5(cast(coalesce(cast("affected_status" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("paternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_2_8,
    count(distinct md5(cast(coalesce(cast("family_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("proband_relationship" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_3_4,
    count(distinct md5(cast(coalesce(cast("family_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("project_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_3_5,
    count(distinct md5(cast(coalesce(cast("family_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("sex" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_3_6,
    count(distinct md5(cast(coalesce(cast("family_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("maternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_3_7,
    count(distinct md5(cast(coalesce(cast("family_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("paternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_3_8,
    count(distinct md5(cast(coalesce(cast("proband_relationship" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("project_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_4_5,
    count(distinct md5(cast(coalesce(cast("proband_relationship" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("sex" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_4_6,
    count(distinct md5(cast(coalesce(cast("proband_relationship" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("maternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_4_7,
    count(distinct md5(cast(coalesce(cast("proband_relationship" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("paternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_4_8,
    count(distinct md5(cast(coalesce(cast("project_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("sex" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_5_6,
    count(distinct md5(cast(coalesce(cast("project_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("maternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_5_7,
    count(distinct md5(cast(coalesce(cast("project_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("paternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_5_8,
    count(distinct md5(cast(coalesce(cast("sex" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("maternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_6_7,
    count(distinct md5(cast(coalesce(cast("sex" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("paternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_6_8,
    count(distinct md5(cast(coalesce(cast("maternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("paternal_id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT))) as n_7_8
  from "acr_dbt_pipeline"."main_cmg"."cmg_main_subject"
),
pairs as (
  select
    n_rows,
    'subject_id' as column_a,
    'affected_status' as column_b,
    n_1 as distinct_a,
    n_2 as distinct_b,
    n_1_2 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'subject_id' as column_a,
    'family_id' as column_b,
    n_1 as distinct_a,
    n_3 as distinct_b,
    n_1_3 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'subject_id' as column_a,
    'proband_relationship' as column_b,
    n_1 as distinct_a,
    n_4 as distinct_b,
    n_1_4 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'subject_id' as column_a,
    'project_id' as column_b,
    n_1 as distinct_a,
    n_5 as distinct_b,
    n_1_5 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'subject_id' as column_a,
    'sex' as column_b,
    n_1 as distinct_a,
    n_6 as distinct_b,
    n_1_6 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'subject_id' as column_a,
    'maternal_id' as column_b,
    n_1 as distinct_a,
    n_7 as distinct_b,
    n_1_7 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'subject_id' as column_a,
    'paternal_id' as column_b,
    n_1 as distinct_a,
    n_8 as distinct_b,
    n_1_8 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'affected_status' as column_a,
    'family_id' as column_b,
    n_2 as distinct_a,
    n_3 as distinct_b,
    n_2_3 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'affected_status' as column_a,
    'proband_relationship' as column_b,
    n_2 as distinct_a,
    n_4 as distinct_b,
    n_2_4 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'affected_status' as column_a,
    'project_id' as column_b,
    n_2 as distinct_a,
    n_5 as distinct_b,
    n_2_5 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'affected_status' as column_a,
    'sex' as column_b,
    n_2 as distinct_a,
    n_6 as distinct_b,
    n_2_6 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'affected_status' as column_a,
    'maternal_id' as column_b,
    n_2 as distinct_a,
    n_7 as distinct_b,
    n_2_7 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'affected_status' as column_a,
    'paternal_id' as column_b,
    n_2 as distinct_a,
    n_8 as distinct_b,
    n_2_8 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'family_id' as column_a,
    'proband_relationship' as column_b,
    n_3 as distinct_a,
    n_4 as distinct_b,
    n_3_4 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'family_id' as column_a,
    'project_id' as column_b,
    n_3 as distinct_a,
    n_5 as distinct_b,
    n_3_5 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'family_id' as column_a,
    'sex' as column_b,
    n_3 as distinct_a,
    n_6 as distinct_b,
    n_3_6 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'family_id' as column_a,
    'maternal_id' as column_b,
    n_3 as distinct_a,
    n_7 as distinct_b,
    n_3_7 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'family_id' as column_a,
    'paternal_id' as column_b,
    n_3 as distinct_a,
    n_8 as distinct_b,
    n_3_8 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'proband_relationship' as column_a,
    'project_id' as column_b,
    n_4 as distinct_a,
    n_5 as distinct_b,
    n_4_5 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'proband_relationship' as column_a,
    'sex' as column_b,
    n_4 as distinct_a,
    n_6 as distinct_b,
    n_4_6 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'proband_relationship' as column_a,
    'maternal_id' as column_b,
    n_4 as distinct_a,
    n_7 as distinct_b,
    n_4_7 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'proband_relationship' as column_a,
    'paternal_id' as column_b,
    n_4 as distinct_a,
    n_8 as distinct_b,
    n_4_8 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'project_id' as column_a,
    'sex' as column_b,
    n_5 as distinct_a,
    n_6 as distinct_b,
    n_5_6 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'project_id' as column_a,
    'maternal_id' as column_b,
    n_5 as distinct_a,
    n_7 as distinct_b,
    n_5_7 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'project_id' as column_a,
    'paternal_id' as column_b,
    n_5 as distinct_a,
    n_8 as distinct_b,
    n_5_8 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'sex' as column_a,
    'maternal_id' as column_b,
    n_6 as distinct_a,
    n_7 as distinct_b,
    n_6_7 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'sex' as column_a,
    'paternal_id' as column_b,
    n_6 as distinct_a,
    n_8 as distinct_b,
    n_6_8 as distinct_pairs
  from counts
  union all
  select
    n_rows,
    'maternal_id' as column_a,
    'paternal_id' as column_b,
    n_7 as distinct_a,
    n_8 as distinct_b,
    n_7_8 as distinct_pairs
  from counts
)
select
  *,
  case
    when distinct_pairs = distinct_a and distinct_pairs = distinct_b then '1:1'
    when distinct_pairs = distinct_a then 'N:1'
    when distinct_pairs = distinct_b then '1:N'
    else 'N:N'
  end as relationship,
  case
    when distinct_a = 1 or distinct_b = 1 then 'one column is constant'
    when distinct_a = n_rows and distinct_b = n_rows then 'both columns unique per row'
  end as note
from pairs
order by all