{{ config(materialized='table', schema='eMERGEseq_data') }}

    with source as (
        select 
        {{ generate_global_id(prefix='sm',descriptor=['samplesubjectmapping.subject_id', 'samplesubjectmapping.sample_id'], study_id='phs001616') }}::text as "sample_id",
       samplesubjectmapping.sample_id::text as "external_id"
        from {{ ref('eMERGEseq_stg_samplesubjectmapping') }} as samplesubjectmapping
    )

    select 
        * 
    from source
    