{{ config(materialized='table', schema='gregor_synthetic_data') }}

with source as (
        select
        family_id,
        participant_id AS other_family_member,
        twin_id AS participant_id,
        from {{ ref('gregor_synthetic_stg_participant') }} as participant WHERE twin_id != '0'

        UNION 

        select 
        family_id,
        participant_id AS other_family_member, 
        paternal_id AS participant_id,
        from {{ ref('gregor_synthetic_stg_participant') }} as participant WHERE paternal_id != '0'

        UNION 

        select 
        family_id,
        participant_id AS other_family_member, 
        maternal_id AS participant_id,
        from {{ ref('gregor_synthetic_stg_participant') }} as participant WHERE maternal_id != '0'

        UNION 
        -- Normal Direction of family relationship
        SELECT
        participant.family_id,
        proband.participant_id as other_family_member, -- is proband's participant ID. -- Josh changed this as other_family_member, -- is proband's participant ID
        participant.participant_id AS participant_id, -- is not proband's participant ID
        from {{ ref('gregor_synthetic_stg_participant') }} as participant
        LEFT JOIN {{ ref('gregor_synthetic_stg_participant') }} as proband 
        ON proband.family_id = participant.family_id  -- If multiple probands per family, assuming siblings
        AND proband.proband_relationship = 'Self'
        where participant.proband_relationship != 'Self'
          and participant.proband_relationship NOT IN ('Self', 'Niece', 'Nephew')

        UNION 
        -- Flipped Direction of family relationship
        SELECT 
        family_id,
        {{ generate_global_id(prefix='sb',descriptor=['participant.participant_id'], study_id='gregor_synthetic') }}::text as "other_family_member", -- not proband (niece or nephew's ID)
        (   select DISTINCT CAST(participant_id as STRING) FROM {{ ref('gregor_synthetic_stg_participant') }} as stg 
            WHERE CAST(stg.family_id as STRING) = CAST(participant.family_id as STRING) 
                AND CAST(stg.proband_relationship AS STRING) = 'Self'
        ) AS participant_id, -- proband's participant ID
        from {{ ref('gregor_synthetic_stg_participant') }} as participant
        where participant.proband_relationship IN ('Niece', 'Nephew')
    )


        select distinct
        {{ generate_global_id(prefix='fr',descriptor=['family_id','participant_id','source.other_family_member'],study_id='gregor_synthetic') }}::text as "FamilyRelationship_id",
        participant_id::text as "external_id"
        from source
    