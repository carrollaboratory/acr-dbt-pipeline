
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_int_sample__dbt_tmp"
  
    
    as (
      with base as (
select
  sa."datarepo_row_id",
  sa."sample_id",
  sa."crai",
  sa."cram",
  sa."sample_source",
  sa."ingest_provenance",
  sa."source_snapshot",
  sa."source_snapshot_id",
  sa."subject_id",
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
  -- most snapshots record sequencing_center on sample; uwash_ds_bdis records it on subject
  coalesce(sa."sequencing_center", s."subject_sequencing_center") as sequencing_center,
  'sa' || '_' || md5(coalesce(nullif(replace(regexp_replace(trim(cast(sa.subject_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(sa.sample_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(s.consent_group as text)), '\s+', ' ', 'g'), '|', '/|'), ''), ''))::text as sample_gid,
  'subject_id|sample_id|consent_group:sa-[' || coalesce(nullif(replace(regexp_replace(trim(cast(sa.subject_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(sa.sample_id as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || '|' || coalesce(nullif(replace(regexp_replace(trim(cast(s.consent_group as text)), '\s+', ' ', 'g'), '|', '/|'), ''), '') || ']'::text as sample_id_descriptor
from "acr_dbt_pipeline"."main_cmg"."cmg_main_sample" sa
left join (
select distinct
  subject_id,
  source_snapshot_id,
  subject_gid,
  subject_id_descriptor,
  person_gid,
  person_id_descriptor,
  study_gid,
  study_id_descriptor,
  access_policy_gid,
  access_policy_descriptor,
  consent_group,
  sequencing_center as subject_sequencing_center
from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject" ) s
using (subject_id, source_snapshot_id)
),
sample_source_mappings as (
  select 
  source_text::text as sample_source,
  mapped_code::text as sample_source_mapped_code,
  concept_curie as sample_source_concept_curie,
  concept_uri_or_curie as sample_source_concept_uri_or_curie,
  concept_display as sample_source_concept_display,
  concept_definition as sample_source_concept_definition,
  vocabulary_prefix as sample_source_vocabulary_prefix,
  fhir_system as sample_source_fhir_system
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_mapdragon_annotations"
  where source_system = 'https://anvilproject.org//sample_source'
  )
  
select -- join the annotations
  base.*,
  sample_source_mapped_code,
  sample_source_concept_curie,
  sample_source_concept_uri_or_curie,
  sample_source_concept_display,
  sample_source_concept_definition,
  sample_source_vocabulary_prefix,
  sample_source_fhir_system
from base
left join sample_source_mappings
using (sample_source)
    );
    
  