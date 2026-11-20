-- Drill-down for one pair from cmg_profile_subject_relationships:
-- lists the values that break a 1:1 mapping. Empty result = 1:1. See analysis/README.md.
with pairs as (
  select distinct
    "source_snapshot",
    cast("subject_id" as varchar) as value_a,
    cast("family_id" as varchar) as value_b
  from "acr_dbt_pipeline"."main_cmg"."cmg_main_subject"
)
select
  "source_snapshot",
  'subject_id -> family_id' as direction,
  value_a as value,
  count(*) as n_other_values,
  list(value_b order by value_b)[1:10] as other_values
from pairs
group by all
having count(*) > 1
union all
select
  "source_snapshot",
  'family_id -> subject_id' as direction,
  value_b as value,
  count(*) as n_other_values,
  list(value_a order by value_a)[1:10] as other_values
from pairs
group by all
having count(*) > 1
order by direction, n_other_values desc, value