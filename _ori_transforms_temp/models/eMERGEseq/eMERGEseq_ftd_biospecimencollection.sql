{{ config(materialized='table', schema='eMERGEseq_data') }}

    with source as (
        select 
        GEN_UNKNOWN.age_at_collection::integer as "age_at_collection",
       GEN_UNKNOWN.method::text as "method",
       GEN_UNKNOWN.site::text as "site",
       GEN_UNKNOWN.spatial_qualifier::text as "spatial_qualifier",
       GEN_UNKNOWN.laterality::text as "laterality",
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
    