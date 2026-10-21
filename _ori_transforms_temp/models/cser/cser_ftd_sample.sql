{{ config(materialized='table', schema='cser_data') }}

select DISTINCT
  NULL::text as "parent_sample",
  st.curie::text as "sample_type",
  NULL::text as "availablity_status",
  NULL::text as "quantity_number",
  NULL::text as "quantity_units",
    {{ generate_global_id(prefix='ap',descriptor=['consent_id'], study_id='cser') }}::text as "has_access_policy",
    {{ generate_global_id(prefix='sm',descriptor=['subject_id','sample_id'], study_id='cser') }}::text as "id",
    {{ generate_global_id(prefix='sb',descriptor=['subject_id','consent_id'], study_id='cser') }}::text as "subject_id",
    NULL::text as "biospecimen_collection_id"
from {{ ref('cser_stg_sample') }} as s
left join {{ ref('sm_sample_type') }} as st
on lower(s.sample_source)= lower(st.src_format)