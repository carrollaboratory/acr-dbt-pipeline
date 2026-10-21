{{ config(materialized='table', schema='cmg_bh_data') }}

with
lookup as (
    select -- annotations from src
      "searched_code" as join_code,
      "searched_code" as code,
      "display" as display
    from {{ ref('cmg_bh_annotations_code') }}
    
    union all
    
    select -- annotations from MD
      "local code" as join_code,
      "code" as code,
      "display" as display
    from {{ ref('subject_mappings') }}
)

select 
  distinct
  'phenotypic_feature'::text as "assertion_type",
  NULL::text as "age_at_assertion",
  NULL::text as "age_at_event",
  NULL::text as "age_at_resolution",
  lookup.code as "code",
  lookup.display as "display",
    case lower(presence)
    when 'affected' then 'LA9633-4'
    when 'unaffected' then 'LA9634-2'
    when 'unknown' then 'LA4489-6'
    when presence is null then 'LA4489-6'
    else CONCAT('FTD_FLAG:unhandled value_code: ',presence)
  end::text as "value_code",
    case lower(presence)
    when 'affected' then 'Affected'
    when 'unaffected' then 'Unaffected'
    when 'unknown' then 'Unknown'
    when presence is null then 'Unknown'
    else CONCAT('FTD_FLAG:unhandled value_display: ',presence)
  end::text as "value_display",  
  NULL::text as "value_number",
  NULL::text as "value_units",
  NULL::text as "value_units_display",
  {{ generate_global_id(prefix='ap',descriptor=['ingest_provenance'], study_id='cmg_bh') }}::text as "has_access_policy",
  {{ generate_global_id(prefix='sa',descriptor=['subject_id','condition_or_disease_code'], study_id='cmg_bh') }}::text as "id",
  {{ generate_global_id(prefix='sb',descriptor=['subject_id'], study_id='cmg_bh') }}::text as "subject_id"
from (select distinct ingest_provenance, subject_id, condition_or_disease_code, presence from {{ ref('cmg_bh_stg_subject') }}) as s
join lookup
on s.condition_or_disease_code = lookup.join_code