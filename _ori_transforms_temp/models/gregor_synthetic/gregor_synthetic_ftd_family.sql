{{ config(materialized='table', schema='gregor_synthetic_data') }}

    with source as (
        select 
        NULL::text as "family_type",
        NULL::text as "family_description",
        NULL::text as "consanguinity",
        NULL::text as "family_study_focus",
        NULL::text as "has_access_policy",
        NULL::text as "id"
    )

    select 
        * 
    from source
    