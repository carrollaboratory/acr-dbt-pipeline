{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  {{ generate_global_id(prefix='ap',descriptor=['consent_group'], study_id='cmg_yale') }}::text as "accesspolicy_id",
  consent_group::text as "external_id"
from (select distinct consent_group from {{ ref('cmg_yale_stg_anvil_dataset') }}) as s