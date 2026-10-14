{{ config(materialized='table', schema='cmg_yale_data') }}

select 
  distinct
  disease_limitation,
  consent_group as "ftd_consent_group",
  consent_description::text as "description",
  NULL::text as "website",
  {{ generate_global_id(prefix='ap',descriptor=['consent_group'], study_id='cmg_yale') }}::text as "id"
from (select distinct ad.consent_group, cc.consent_description, cc.disease_limitation
      from {{ ref('cmg_yale_stg_anvil_dataset') }} as ad
      left join {{ ref('ap_access_policy') }} as cc
      on cc.consent_code = ad.consent_group
      ) as s