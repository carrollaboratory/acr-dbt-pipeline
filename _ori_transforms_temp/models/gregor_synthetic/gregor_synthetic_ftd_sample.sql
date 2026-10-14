{{ config(materialized='table', schema='gregor_synthetic_data') }}

    with source as (
        select 
       NULL::text as "parent_sample",
       NULL::text as "sample_type",
       NULL::text as "availablity_status",
       NULL::text as "quantity_number",
       NULL::text as "quantity_units",
       NULL::text as "has_access_policy",
       NULL::text as "id",
       NULL::text as "subject_id",
       NULL::text as "biospecimen_collection_id"
    )

    select 
        * 
    from source
    