{{ config(materialized='table', schema='eMERGEseq_data') }}

    with source as (
        select 
        GEN_UNKNOWN.snapshot_id::text as "snapshot_id",
       GEN_UNKNOWN.google_data_project::text as "google_data_project",
       GEN_UNKNOWN.snapshot_dataset::text as "snapshot_dataset",
       GEN_UNKNOWN.table::text as "table",
       GEN_UNKNOWN.parameterized_query::text as "parameterized_query",
       {{ generate_global_id(prefix='',descriptor=[''], study_id='eMERGEseq') }}::text as "id"
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
    