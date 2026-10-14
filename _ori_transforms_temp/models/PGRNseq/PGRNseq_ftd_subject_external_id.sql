{{ config(materialized='table', schema='PGRNseq_data') }}

select distinct
  {{ generate_global_id(prefix='sb',descriptor=['subjectconsent.subject_id', 'subjectconsent.consent'], study_id='phs000906') }}::text as "subject_id",
  subjectconsent.subject_id::text as "external_id"
from {{ ref('PGRNseq_stg_subjectconsent') }} as subjectconsent
