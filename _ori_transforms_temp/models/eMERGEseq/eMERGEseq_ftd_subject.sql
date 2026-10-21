{{ config(materialized='table', schema='eMERGEseq_data') }}

    with source as (
        select DISTINCT
         CASE 
            WHEN subjectconsent.consent != 0 THEN 'participant'
            ELSE 'non_participant'
        END::text as subject_type,
        NULL as "organism_type",
       {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "has_access_policy",
       {{ generate_global_id(prefix='sb',descriptor=['subjectconsent.subject_id'], study_id='phs001616') }}::text as "id",
       {{ generate_global_id(prefix='dm',descriptor=['demographics.subject_id'], study_id='phs001616') }}::text as "has_demographics_id"
        from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
        left join {{ ref('eMERGEseq_stg_demographics') }} as demographics
        on subjectconsent.subject_id = demographics.subject_id
    )

    select 
        * 
    from source
    