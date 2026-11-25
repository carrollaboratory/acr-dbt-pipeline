-- Which datasets populate which columns. Change the table or options below.
-- measure: 'any' (1/0), 'count' or 'proportion'. See analysis/README.md.
select
  "ingest_provenance",
  count(*) as n_rows,
  max(case when "subject_id" is not null then 1 else 0 end) as "subject_id",
  max(case when "affected_status" is not null then 1 else 0 end) as "affected_status",
  max(case when "ancestry" is not null then 1 else 0 end) as "ancestry",
  max(case when "ancestry_detail" is not null then 1 else 0 end) as "ancestry_detail",
  max(case when "dbgap_study_id" is not null then 1 else 0 end) as "dbgap_study_id",
  max(case when "dbgap_submission" is not null then 1 else 0 end) as "dbgap_submission",
  max(case when "disease_description" is not null then 1 else 0 end) as "disease_description",
  max(case when "disease_id" is not null then 1 else 0 end) as "disease_id",
  max(case when "family_id" is not null then 1 else 0 end) as "family_id",
  max(case when "hpo_present" is not null then 1 else 0 end) as "hpo_present",
  max(case when "multiple_datasets" is not null then 1 else 0 end) as "multiple_datasets",
  max(case when "proband_relationship" is not null then 1 else 0 end) as "proband_relationship",
  max(case when "project_id" is not null then 1 else 0 end) as "project_id",
  max(case when "sex" is not null then 1 else 0 end) as "sex",
  max(case when "maternal_id" is not null then 1 else 0 end) as "maternal_id",
  max(case when "paternal_id" is not null then 1 else 0 end) as "paternal_id",
  max(case when "source_snapshot" is not null then 1 else 0 end) as "source_snapshot",
  max(case when "source_snapshot_id" is not null then 1 else 0 end) as "source_snapshot_id",
  max(case when "sample_id" is not null then 1 else 0 end) as "sample_id",
  max(case when "phenotype_description" is not null then 1 else 0 end) as "phenotype_description",
  max(case when "congenital_status" is not null then 1 else 0 end) as "congenital_status",
  max(case when "dbgap_subject_id" is not null then 1 else 0 end) as "dbgap_subject_id",
  max(case when "pmid_id" is not null then 1 else 0 end) as "pmid_id",
  max(case when "solve_state" is not null then 1 else 0 end) as "solve_state",
  max(case when "prior_testing" is not null then 1 else 0 end) as "prior_testing",
  max(case when "age_at_last_observation" is not null then 1 else 0 end) as "age_at_last_observation",
  max(case when "twin_id" is not null then 1 else 0 end) as "twin_id",
  max(case when "sequencing_center" is not null then 1 else 0 end) as "sequencing_center"
from "acr_dbt_pipeline"."main_cmg"."cmg_main_subject"
group by all
order by all