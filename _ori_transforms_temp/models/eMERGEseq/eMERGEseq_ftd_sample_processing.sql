{{ config(materialized='table', schema='eMERGEseq_data') }}

    with source as (
        select 
        {{ generate_global_id(prefix='',descriptor=[''], study_id='eMERGEseq') }}::text as "sample_id",
       GEN_UNKNOWN.processing::text as "processing"
        from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
        join {{ ref('eMERGEseq_stg_demographics') }} as demographics
on subjectconsent.subject_id = demographics.subject_id  join {{ ref('eMERGEseq_stg_phecode') }} as phecode
on   join {{ ref('eMERGEseq_stg_samplesubjectmapping') }} as samplesubjectmapping
on   join {{ ref('eMERGEseq_stg_sampleattributes') }} as sampleattributes
on  
    )

    select 
        * 
    from source
    