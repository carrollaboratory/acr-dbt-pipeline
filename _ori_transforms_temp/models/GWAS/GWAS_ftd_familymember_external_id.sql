{{ config(materialized='table', schema='GWAS_data') }}

    with source as (
        select 
        {{ generate_global_id(prefix='fm',descriptor=['subject_id', 'family_id'], study_id='phs001584') }}::text as "familymember_id",
        subject_id::text as "external_id"
        from {{ ref('GWAS_stg_pedigree') }} as pedigree
    )

    select 
        * 
    from source
    