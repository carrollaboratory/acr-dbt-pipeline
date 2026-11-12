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
)

select
  ad.source_snapshot_id::text as source_snapshot_id,
  ad.source_snapshot::text as source_snapshot, 
  ad.registered_identifier::text as registered_identifier,
  sup.consent_group::text as consent_group,
  'st' || '_' || md5(cast(coalesce(registered_identifier, '') as text))::text  as study_gid,
  'co' || '_' || md5(cast(coalesce(consent_group, '') as text))::text  as access_policy_gid,
  concat('registered_identifier:st-[', ad.registered_identifier::text, ']') AS study_id_descriptor,
  concat('consent_group:co-[', sup.consent_group::text, ']') AS access_policy_descriptor
from  "acr_dbt_pipeline"."main_cmg"."cmg_main_anvil_dataset" as ad
left join supplement_consent_data as sup
on source_snapshot_id = source_snapshot_url_id