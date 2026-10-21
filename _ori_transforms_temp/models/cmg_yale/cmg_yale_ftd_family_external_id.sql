{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  {{ generate_global_id(prefix='fy',descriptor=['family_id'], study_id='cmg_yale') }}::text as "family_id",
   family_id::text as "external_id"
from (select distinct family_id from {{ ref('cmg_yale_stg_subject') }}) as s 