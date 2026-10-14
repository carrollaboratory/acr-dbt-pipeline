{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  {{ generate_global_id(prefix='sd',descriptor=['project_id'], study_id='cmg_yale') }}::text as "sourcedata_id",
  project_id::text as "external_id"
from (select distinct project_id, consent_id from {{ ref('cmg_yale_stg_subject') }} ) AS s