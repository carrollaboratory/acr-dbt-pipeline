{{ config(materialized='table', schema='cmg_yale_data') }}
with
clean_study_data as (
    select 
    distinct
    l_title as "clean_title",
    registered_identifier,
    ad.title as "title_display",
    (select distinct dbgap_study_id from {{ ref('cmg_yale_stg_subject') }} where dbgap_study_id is not null) as "p_study"
    from (
        select 
            distinct 
            dbgap_study_id,
            replace(replace(replace(replace(lower(ingest_provenance), 'subject_', ''),'participant_',''), '.tsv', ''),'-','_') as  "l_title",
            replace(replace(replace(ingest_provenance, 'subject_', ''),'participant_',''), '.tsv', '') as "title"
        from {{ ref('cmg_yale_stg_subject') }}
    ) as sb
    full outer join (
        select 
            distinct registered_identifier,
            replace(lower(title),'-','_') as "l_title",
            title
        from {{ ref('cmg_yale_stg_anvil_dataset') }}
    ) as ad
    using (l_title)
)
select distinct * 
from (
select -- child studies
  distinct
  p_study::text as "parent_study_id",
  concat('Yale Center for Mendelian Genomics (Y CMG) version_',registered_identifier) as "study_title", 
  {{ generate_global_id(prefix='st',descriptor=['registered_identifier'], study_id='cmg_yale') }}::text as "id",
  registered_identifier as "ftd_registered_identifier"
from clean_study_data
where registered_identifier != p_study
     
union all 

select -- parent study
  distinct
  NULL::text as "parent_study_id",
  'Yale Center for Mendelian Genomics (Y CMG)' as "study_title", 
  {{ generate_global_id(prefix='st',descriptor=['p_study'], study_id='cmg_yale') }}::text as "id",
  registered_identifier as "ftd_registered_identifier"
from clean_study_data
) as s