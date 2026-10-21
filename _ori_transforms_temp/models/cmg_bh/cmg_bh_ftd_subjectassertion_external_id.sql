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
   {{ generate_global_id(prefix='sa',descriptor=['subject_id','code'], study_id='cmg_bh') }}::text as "subjectassertion_id",
   subject_id::text as "external_id"
from (select distinct subject_id, dbgap_study_id from {{ ref('cmg_bh_stg_subject') }} ) as s
left join lookup
on code = lookup.join_code