{{ config(materialized='table', schema='eMERGEseq_data') }}

    with source as (
        select 
        {{ generate_global_id(prefix='fm',descriptor=['pedigree.subject_id', 'pedigree.family_id'], study_id='phs001616') }}::text as "familymember_id",
       pedigree.subject_id::text as "external_id"
        from {{ ref('eMERGEseq_stg_pedigree') }} as pedigree
    )

    select 
        * 
    from source
    