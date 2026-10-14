{{ config(materialized='table', schema='GWAS_data') }}

select DISTINCT
  NULL as "parent_sample",
  CASE WHEN sampleattributes.analyte_type = 'DNA' THEN 'LNC:LP18329-0'
       ELSE CONCAT('FTD_FLAG: unhandled sample_type: ',analyte_type)
  END::text as "sample_type",
  NULL as "availablity_status",
  NULL as "quantity_number",
  NULL as "quantity_units",
    {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001584') }}::text as "has_access_policy",
    {{ generate_global_id(prefix='sm',descriptor=['samplesubjectmapping.subject_id', 'samplesubjectmapping.source_sampid'], study_id='phs001584') }}::text as "id",
    {{ generate_global_id(prefix='sb',descriptor=['samplesubjectmapping.subject_id'], study_id='phs001584') }}::text as "subject_id",
    NULL as "biospecimen_collection_id"
from {{ ref('GWAS_stg_sampleattributes') }} as sampleattributes
left join {{ ref('GWAS_stg_samplesubjectmapping') }} as samplesubjectmapping
using (sample_id)
left join {{ ref('GWAS_stg_subjectconsent') }} as subjectconsent
using (subject_id)

