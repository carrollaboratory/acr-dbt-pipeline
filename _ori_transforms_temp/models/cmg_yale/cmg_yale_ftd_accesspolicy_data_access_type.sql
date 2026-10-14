{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  {{ generate_global_id(prefix='ap',descriptor=['consent_group'], study_id='cmg_yale') }}::text as "accesspolicy_id",
  data_access_type,
  consent_group as "ftd_consent_group"
from (select distinct consent_group, data_access_type
      from {{ ref('cmg_yale_stg_anvil_dataset') }} as ad
      left join {{ ref('ap_access_policy') }} as cc
      on cc.consent_code = ad.consent_group
      ) as s