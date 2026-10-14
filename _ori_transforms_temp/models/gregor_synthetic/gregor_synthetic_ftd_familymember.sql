{{ config(materialized='table', schema='gregor_synthetic_data') }}

    with source as (
        select distinct
        {{ generate_global_id(prefix='fm',descriptor=['participant.participant_id'], study_id='gregor_synthetic') }}::text as "family_member",
        CASE participant.proband_relationship
            WHEN 'Mother' THEN 'MTH'
            WHEN 'Father' THEN 'FTH'
            WHEN 'Sibling' THEN 'SIB'
            WHEN 'Child' THEN 'CHILD'
            WHEN 'Maternal Half Sibling' THEN 'HSIB'
            WHEN 'Paternal Half Sibling' THEN 'HSIB'
            WHEN 'Maternal Grandmother' THEN 'MGRMTH'
            WHEN 'Maternal Grandfather' THEN 'MGRFTH'
            WHEN 'Paternal Grandmother' THEN 'PGRMTH'
            WHEN 'Paternal Grandfather' THEN 'PGRFTH'
            WHEN 'Maternal Aunt' THEN 'MAUNT'
            WHEN 'Paternal Aunt' THEN 'PAUNT'
            WHEN 'Maternal Uncle' THEN 'MUNCLE'
            WHEN 'Paternal Uncle' THEN 'PUNCLE'
            WHEN 'Niece' THEN 'NIECE'
            WHEN 'Nephew' THEN 'NEPHEW'
            WHEN 'Maternal 1st Cousin' THEN 'MCOUSN'
            WHEN 'Paternal 1st Cousin' THEN 'PCOUSN'
            WHEN 'Self' THEN 'SNOMED:85900004'
        END::text as "family_role",       
        {{ generate_global_id(prefix='ap',descriptor=['participant.consent_code'], study_id='gregor_synthetic') }}::text as "has_access_policy",
        {{ generate_global_id(prefix='fm',descriptor=['participant.family_id', 'participant.participant_id', 'participant.consent_code'], study_id='gregor_synthetic') }}::text as "id",
       {{ generate_global_id(prefix='fy',descriptor=['participant.family_id'], study_id='gregor_synthetic') }}::text as "family_id"
        from {{ ref('gregor_synthetic_stg_participant') }} as participant
    )

    select 
        * 
    from source
    