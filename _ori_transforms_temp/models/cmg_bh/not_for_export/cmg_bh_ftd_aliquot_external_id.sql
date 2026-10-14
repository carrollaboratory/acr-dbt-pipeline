{{ config(materialized='table', schema='cmg_bh_data') }}

    with source as (
        select 
        {{ generate_global_id(prefix='',descriptor=[''], study_id='cmg_bh') }}::text as "aliquot_id",
       GEN_UNKNOWN.external_id::text as "external_id"
        from {{ ref('cmg_bh_stg_sample') }} as sample
        join {{ ref('cmg_bh_stg_subject') }} as subject
on sample.subject_id = subject.subject_id 
    )

    select 
        * 
    from source
    