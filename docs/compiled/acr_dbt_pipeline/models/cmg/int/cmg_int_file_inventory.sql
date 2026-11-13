-- Files carry no sample/sequencing id; sample and sequencing rows point at file_inventory.file_ref.
with sequencing_links as (
  select
    source_snapshot_id,
    cast(sequencing_id_fileref as varchar) as file_ref,
    sequencing_id,
    assay_gid,
    assay_id_descriptor,
    sample_id,
    sample_gid,
    sample_id_descriptor,
    subject_id,
    subject_gid,
    subject_id_descriptor,
    person_gid,
    person_id_descriptor
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_sequencing"
  where sequencing_id_fileref is not null
  union
  select
    source_snapshot_id,
    cast(seq_filename as varchar) as file_ref,
    sequencing_id,
    assay_gid,
    assay_id_descriptor,
    sample_id,
    sample_gid,
    sample_id_descriptor,
    subject_id,
    subject_gid,
    subject_id_descriptor,
    person_gid,
    person_id_descriptor
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_sequencing"
  where seq_filename is not null
),
sample_links as (
  select
    source_snapshot_id,
    cast(cram as varchar) as file_ref,
    cast(null as text) as sequencing_id,
    cast(null as text) as assay_gid,
    cast(null as text) as assay_id_descriptor,
    sample_id,
    sample_gid,
    sample_id_descriptor,
    subject_id,
    subject_gid,
    subject_id_descriptor,
    person_gid,
    person_id_descriptor
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_sample"
  where cram is not null
  union
  select
    source_snapshot_id,
    cast(crai as varchar) as file_ref,
    cast(null as text) as sequencing_id,
    cast(null as text) as assay_gid,
    cast(null as text) as assay_id_descriptor,
    sample_id,
    sample_gid,
    sample_id_descriptor,
    subject_id,
    subject_gid,
    subject_id_descriptor,
    person_gid,
    person_id_descriptor
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_sample"
  where crai is not null
  union
  select
    source_snapshot_id,
    cast(bam as varchar) as file_ref,
    cast(null as text) as sequencing_id,
    cast(null as text) as assay_gid,
    cast(null as text) as assay_id_descriptor,
    sample_id,
    sample_gid,
    sample_id_descriptor,
    subject_id,
    subject_gid,
    subject_id_descriptor,
    person_gid,
    person_id_descriptor
  from "acr_dbt_pipeline"."main_cmg"."cmg_int_sample"
  where bam is not null
),
-- a sequencing link already carries the sample/subject, so sample links only fill files sequencing doesn't reach
links as (
  select * from sequencing_links
  union all
  select sl.*
  from sample_links sl
  where not exists (
    select 1 from sequencing_links q
    where q.source_snapshot_id = sl.source_snapshot_id
      and q.file_ref = sl.file_ref
  )
),

base as (
select
  fi."datarepo_row_id",
  fi."file_id",
  fi."name",
  fi."path",
  fi."uri",
  fi."content_type",
  fi."full_extension",
  fi."size_in_bytes",
  fi."crc32c",
  fi."md5_hash",
  fi."file_ref",
  fi."ingest_provenance",
  fi."source_snapshot",
  fi."source_snapshot_id",
  l."sequencing_id",
  l."assay_gid",
  l."assay_id_descriptor",
  l."sample_id",
  l."sample_gid",
  l."sample_id_descriptor",
  l."subject_id",
  l."subject_gid",
  l."subject_id_descriptor",
  l."person_gid",
  l."person_id_descriptor",
  ad."study_gid",
  ad."study_id_descriptor",
  ad."access_policy_gid",
  ad."access_policy_descriptor",
  ad."consent_group",
  'fi' || '_' || md5(cast(coalesce(fi.file_id, '') as text) || '|' || cast(coalesce(ad.consent_group, '') as text))::text as file_gid,
  concat('file_id|consent_group:fi-[', fi."file_id", '|', ad."consent_group", ']') AS file_id_descriptor
from "acr_dbt_pipeline"."main_cmg"."cmg_main_file_inventory" fi
left join links l
  on l.source_snapshot_id = fi.source_snapshot_id
  and l.file_ref = cast(fi.file_ref as varchar)
left join (
select
  source_snapshot_id,
  study_gid,
  study_id_descriptor,
  access_policy_gid,
  access_policy_descriptor,
  consent_group
from "acr_dbt_pipeline"."main_cmg"."cmg_int_anvil_dataset" ) ad
  on ad.source_snapshot_id = fi.source_snapshot_id
)

select
  base.*
from base