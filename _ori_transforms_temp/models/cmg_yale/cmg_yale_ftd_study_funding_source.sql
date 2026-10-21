{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  {{ generate_global_id(prefix='st',descriptor=['registered_identifier'], study_id='cmg_yale') }}::text as "study_id",
  NULL::text as "funding_source"
from (select distinct registered_identifier 
      from {{ ref('cmg_yale_stg_anvil_dataset') }} 
      where registered_identifier is not null
     ) as s