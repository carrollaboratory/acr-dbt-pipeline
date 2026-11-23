
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_int_anvil_dataset__dbt_tmp"
  
    
    as (
      with supplement_consent_data as (
select
c."institution",
  c."dataset_name",
  c."consent_group",
  c."data_use_permission",
  c."data_use_permission_duo_code",
  c."disease_shortcode",
  c."disease_limitation",
  c."related_disorders_included",
  c."age_restriction",
  c."mesh_terms",
  c."mesh_ids",
  c."mesh_match_type",
  c."data_use_modifier",
  c."data_use_modifier_duo_codes",
  c."is_irb_required",
  c."review_notes",
  c."duos_id",
  c."snapshot_url",
replace(snapshot_url,'https://data.terra.bio/snapshots/','') as source_snapshot_url_id
from "acr_dbt_pipeline"."main_cmg"."consent_mapping_datasets" c
where institution in ('Yale','UWash')
),

dataset as (
select
  ad.source_snapshot_id::text as source_snapshot_id,
  ad.source_snapshot::text as source_snapshot,
  array_to_string(ad.registered_identifier, ',')::text as registered_identifier,
  sup.consent_group::text as consent_group,
  ad.dataset_id::text as dataset_id,
  ad.title::text as dataset_title,
  sup.data_use_permission_duo_code::text as data_use_permission_duo_code,
  sup.data_use_modifier_duo_codes::text as data_use_modifier_duo_codes,
  sup.disease_limitation::text as disease_limitation
from  "acr_dbt_pipeline"."main_cmg"."cmg_main_anvil_dataset" as ad
left join supplement_consent_data as sup
on source_snapshot_id = source_snapshot_url_id
)

select
  source_snapshot_id,
  source_snapshot,
  registered_identifier,
  consent_group,
  'st' || '_' || md5(coalesce(nullif(replace(regexp_replace(trim(cast(registered_identifier as text)), '\s+', ' ', 'g'), '|', '/|'), ''), ''))::text  as study_gid,
  'co' || '_' || md5(coalesce(nullif(replace(regexp_replace(trim(cast(registered_identifier as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(consent_group as text)), '\s+', ' ', 'g'), '|', '/|'), ''), ''))::text  as access_policy_gid,
  'registered_identifier:st-[' || coalesce(nullif(replace(regexp_replace(trim(cast(registered_identifier as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || ']'::text as study_id_descriptor,
  'registered_identifier|consent_group:co-[' || coalesce(nullif(replace(regexp_replace(trim(cast(registered_identifier as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(consent_group as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || ']'::text as access_policy_descriptor,
  'ds' || '_' || md5(coalesce(nullif(replace(regexp_replace(trim(cast(source_snapshot_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), ''))::text  as dataset_gid,
  'source_snapshot_id:ds-[' || coalesce(nullif(replace(regexp_replace(trim(cast(source_snapshot_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || ']'::text as dataset_id_descriptor,
  dataset_id,
  dataset_title,
  data_use_permission_duo_code,
  data_use_modifier_duo_codes,
  disease_limitation
from dataset
    );
    
  