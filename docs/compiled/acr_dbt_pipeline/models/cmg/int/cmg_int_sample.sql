with base as (
select
  sa."datarepo_row_id",
  sa."sample_id",
  sa."participant_id",
  sa."crai",
  sa."cram",
  sa."sample_source",
  sa."subject_id",
  sa."ingest_provenance",
  sa."source_snapshot",
  sa."source_snapshot_id",
  sa."participant_id_2",
  sa."bam",
  s."subject_gid",
  s."subject_id_descriptor",
  s."person_gid",
  s."person_id_descriptor",
  s."study_gid",
  s."study_id_descriptor",
  s."access_policy_gid",
  s."access_policy_descriptor",
  s."consent_group",
  s."sequencing_center",
  'sa' || '_' || md5(cast(coalesce(sa.subject_id, '') as text) || '|' || cast(coalesce(sa.sample_id, '') as text) || '|' || cast(coalesce(s.consent_group, '') as text))::text as sample_gid,
  concat('subject_id|sample id|consent_group:sa-[', sa."subject_id", '|', sa."sample_id", '|', s."consent_group", ']') AS sample_id_descriptor
from "acr_dbt_pipeline"."main_cmg"."cmg_main_sample" sa
left join (
select distinct
  subject_id,
  subject_gid,
  subject_id_descriptor,
  person_gid,
  person_id_descriptor,
  study_gid,
  study_id_descriptor,
  access_policy_gid,
  access_policy_descriptor,
  consent_group,
  sequencing_center
from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject" ) s
using (subject_id)
),
sample_source_mappings as (
  select 
  source_text::text as sample_source,
  mapped_code::text as sample_source_mapped_code
  from "acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon"
  where source_system = 'https://anvilproject.org//sample_source'
  )
  
select -- join the annotations
  base.*,
  sample_source_mapped_code
from base
left join sample_source_mappings
using (sample_source)