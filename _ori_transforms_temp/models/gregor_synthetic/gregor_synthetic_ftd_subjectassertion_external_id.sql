{{ config(materialized='table', schema='gregor_synthetic_data') }}

 with source as (
        select 
        participant_id,
        REPLACE(term_id, '?', '')::text as "code",
        from {{ ref('gregor_synthetic_stg_participant') }} as participant
        join {{ ref('gregor_synthetic_stg_phenotype') }} as phenotype
        using(participant_id) 
    )

    select distinct
    {{ generate_global_id(prefix='sa',descriptor=['participant_id','code'], study_id='gregor_synthetic') }}::text as "SubjectAssertion_id",
    participant_id::text as "external_id"
    from source as s
    left join {{ ref('gregor_synthetic_annotations') }} as ga
    on lower(s.code) = lower(ga.searched_code)
    