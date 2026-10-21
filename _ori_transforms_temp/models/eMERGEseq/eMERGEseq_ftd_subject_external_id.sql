{{ config(materialized='table', schema='eMERGEseq_data') }}

    with source as (
        select 
        {{ generate_global_id(prefix='sb',descriptor=['demographics.subject_id'], study_id='phs001616') }}::text as "subject_id",
       demographics.subject_id::text as "external_id"
        from{{ ref('eMERGEseq_stg_demographics') }} as demographics
    )

    select 
        * 
    from source
    