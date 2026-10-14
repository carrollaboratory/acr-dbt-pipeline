{{ config(materialized='table', schema='cmg_bh_data') }}

    with source as (
        select 
        GEN_UNKNOWN.code::text as "code",
       GEN_UNKNOWN.display::text as "display",
       GEN_UNKNOWN.value_code::text as "value_code",
       GEN_UNKNOWN.value_display::text as "value_display",
       {{ generate_global_id(prefix='',descriptor=[''], study_id='cmg_bh') }}::text as "id"
        from {{ ref('cmg_bh_stg_sample') }} as sample
        join {{ ref('cmg_bh_stg_subject') }} as subject
on sample.subject_id = subject.subject_id 
    )

    select 
        * 
    from source
    