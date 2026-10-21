{{ config(materialized='table', schema='cmg_yale_data') }}

select 
    {{ generate_global_id(prefix='sb',descriptor=['subject_id'], study_id='cmg_yale') }}::text as "subject_id",
    subject_id::text as "external_id"
from (select distinct subject_id, consent_id from {{ ref('cmg_yale_stg_subject') }} ) AS s