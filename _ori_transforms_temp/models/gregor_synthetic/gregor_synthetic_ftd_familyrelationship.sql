{{ config(materialized='table', schema='gregor_synthetic_data') }}

    with source as (
        select
        family_id,
        participant_id AS other_family_member,
        twin_id AS participant_id,
        'KIN:009' AS relationship_code,
        {{ generate_global_id(prefix='ap',descriptor=['participant.consent_code'], study_id='gregor_synthetic') }}::text AS "has_access_policy",
        from {{ ref('gregor_synthetic_stg_participant') }} as participant WHERE twin_id != '0'

        UNION 

        select 
        family_id,
        participant_id AS other_family_member, 
        paternal_id AS participant_id,
        'KIN:028' AS relationship_code,
        {{ generate_global_id(prefix='ap',descriptor=['participant.consent_code'], study_id='gregor_synthetic') }}::text AS "has_access_policy",
        from {{ ref('gregor_synthetic_stg_participant') }} as participant WHERE paternal_id != '0'

        UNION 

        select 
        family_id,
        participant_id AS other_family_member, 
        maternal_id AS participant_id,
        'KIN:027' AS relationship_code,
        {{ generate_global_id(prefix='ap',descriptor=['participant.consent_code'], study_id='gregor_synthetic') }}::text AS "has_access_policy",
        from {{ ref('gregor_synthetic_stg_participant') }} as participant WHERE maternal_id != '0'

        UNION 
        -- Normal Direction of family relationship
        SELECT
        participant.family_id,
        proband.participant_id as other_family_member, -- is proband's participant ID. -- Josh changed this as other_family_member, -- is proband's participant ID
        participant.participant_id AS participant_id, -- is not proband's participant ID
       CASE 
           WHEN participant.proband_relationship =  'Mother' THEN 'KIN:027' -- system: http://purl.org/ga4gh/kin.owl
           WHEN participant.proband_relationship =  'Father' THEN 'KIN:028'
           WHEN participant.proband_relationship =  'Sibling' THEN 'KIN:007'
           WHEN participant.proband_relationship =  'Child' THEN 'KIN:032'
           WHEN participant.proband_relationship =  'Maternal Half Sibling' THEN 'KIN:054'
           WHEN participant.proband_relationship =  'Paternal Half Sibling' THEN 'KIN:055'
           WHEN participant.proband_relationship =  'Maternal Grandmother' THEN 'KIN:052'
           WHEN participant.proband_relationship =  'Maternal Grandfather' THEN 'KIN:052'
           WHEN participant.proband_relationship =  'Paternal Grandmother' THEN 'KIN:053'
           WHEN participant.proband_relationship =  'Paternal Grandfather' THEN 'KIN:053'
           WHEN participant.proband_relationship =  'Maternal Aunt' THEN 'KIN:060'
           WHEN participant.proband_relationship =  'Paternal Aunt' THEN 'KIN:061'
           WHEN participant.proband_relationship =  'Maternal Uncle' THEN 'KIN:058'
           WHEN participant.proband_relationship =  'Paternal Uncle' THEN 'KIN:059'           
           WHEN participant.proband_relationship =  'Maternal 1st Cousin' THEN 'KIN:015'
           WHEN participant.proband_relationship =  'Paternal 1st Cousin' THEN 'KIN:016'
           WHEN participant.proband_relationship =  'Other' OR participant.proband_relationship =  'Unknown' THEN 'KIN:001'
        END::text as "relationship_code", 
        {{ generate_global_id(prefix='ap',descriptor=['participant.consent_code'], study_id='gregor_synthetic') }}::text as "has_access_policy",
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
        'KIN:013' AS "relationship_code", -- isParentalSibling   
        {{ generate_global_id(prefix='ap',descriptor=['participant.consent_code'], study_id='gregor_synthetic') }}::text as "has_access_policy",
        from {{ ref('gregor_synthetic_stg_participant') }} as participant
        where participant.proband_relationship IN ('Niece', 'Nephew')
    )

    select DISTINCT
        {{ generate_global_id(prefix='fr',descriptor=['family_id','participant_id','source.other_family_member'],study_id='gregor_synthetic') }}::text as "id",
        relationship_code, 
        {{ generate_global_id(prefix='sb',descriptor=['source.participant_id'], study_id='gregor_synthetic') }}::text AS "family_member",
        {{ generate_global_id(prefix='sb',descriptor=['source.other_family_member'], study_id='gregor_synthetic') }}::text as "other_family_member",
        has_access_policy
    from source
 