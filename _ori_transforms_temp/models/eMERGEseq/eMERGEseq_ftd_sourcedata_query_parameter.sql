{{ config(materialized='table', schema='eMERGEseq_data') }}

    with source as (
        select 
        {{ generate_global_id(prefix='',descriptor=[''], study_id='eMERGEseq') }}::text as "sourcedata_id",
       GEN_UNKNOWN.query_parameter::text as "query_parameter"
        from {{ ref('eMERGEseq_stg_demographics') }} as demographics
        join {{ ref('eMERGEseq_stg_phecode') }} as phecode
on demographics.subject_id = phecode.subject_id  join {{ ref('eMERGEseq_stg_sampleattributes') }} as sampleattributes
on samplesubjectmapping.sample_id = sampleattributes.sample_id  join {{ ref('eMERGEseq_stg_samplesubjectmapping') }} as samplesubjectmapping
on sampleattributes.sample_id = samplesubjectmapping.sample_id  join {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
on   join {{ ref('eMERGEseq_stg_bmi') }} as bmi
on   join {{ ref('eMERGEseq_stg_pedigree') }} as pedigree
on  
    )

    select 
        * 
    from source
    