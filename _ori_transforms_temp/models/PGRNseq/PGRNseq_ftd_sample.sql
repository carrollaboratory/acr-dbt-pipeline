{{ config(materialized='table', schema='PGRNseq_data') }}

select DISTINCT
  NULL as "parent_sample",
  CASE WHEN sampleattribution.analyte_type IN ('DNA', 'NA') THEN 'LNC:LP18329-0'
       ELSE CONCAT('FTD_FLAG: unhandled sample_type: ',analyte_type)
  END::text as "sample_type",
  NULL as "availablity_status",
  NULL as "quantity_number",
  NULL as "quantity_units",
    {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs000906') }}::text as "has_access_policy",
    {{ generate_global_id(prefix='sm',descriptor=['samplesubjectmapping.subject_id', 'samplesubjectmapping.sample_id', 'subjectconsent.consent'], study_id='phs000906') }}::text as "id",
    {{ generate_global_id(prefix='sb',descriptor=['samplesubjectmapping.subject_id', 'subjectconsent.consent'], study_id='phs000906') }}::text as "subject_id",
    NULL as "biospecimen_collection_id"
from {{ ref('PGRNseq_stg_sampleattribution') }} as sampleattribution
left join {{ ref('PGRNseq_stg_samplesubjectmapping') }} as samplesubjectmapping
using (sample_id)
left join {{ ref('PGRNseq_stg_subjectconsent') }} as subjectconsent
using (subject_id)
