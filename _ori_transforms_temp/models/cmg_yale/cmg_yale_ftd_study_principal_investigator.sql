{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  {{ generate_global_id(prefix='st',descriptor=['registered_identifier'], study_id='cmg_yale') }}::text::text as "study_id",
  principal_investigator::text as "principal_investigator"
from (
    select distinct principal_investigator, registered_identifier 
    from {{ ref('cmg_yale_stg_anvil_dataset') }}
    ) as s