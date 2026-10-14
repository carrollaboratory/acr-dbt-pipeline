{{ config(materialized='table', schema='cmg_yale_data') }}

with
clean_study_data as (
    select 
    distinct
    l_title as "clean_title",
    registered_identifier,
    ad.title as "title_display"
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
    USING (l_title)
)

select 
    {{ generate_global_id(prefix='st',descriptor=['registered_identifier'], study_id='cmg_yale') }}::text as "study_id",
    registered_identifier::text as "external_id"
from clean_study_data