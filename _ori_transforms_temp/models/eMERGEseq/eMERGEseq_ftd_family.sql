{{ config(materialized='table', schema='eMERGEseq_data') }}

    with source as (
        select 
        GEN_UNKNOWN.family_type::text as "family_type",
       GEN_UNKNOWN.family_description::text as "family_description",
       GEN_UNKNOWN.consanguinity::text as "consanguinity",
       GEN_UNKNOWN.family_study_focus::text as "family_study_focus",
       {{ generate_global_id(prefix='',descriptor=[''], study_id='eMERGEseq') }}::text as "has_access_policy",
       {{ generate_global_id(prefix='',descriptor=[''], study_id='eMERGEseq') }}::text as "id"
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
    