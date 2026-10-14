{{ config(materialized='table', schema='gregor_synthetic_data') }}

    with source as (
        select 
       NULL::text as "parent_study_id",
       NULL::text as "study_title",
       NULL::text as "id"
    )

    select 
        * 
    from source
    