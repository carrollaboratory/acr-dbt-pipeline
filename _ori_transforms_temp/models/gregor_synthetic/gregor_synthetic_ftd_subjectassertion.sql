{{ config(materialized='table', schema='gregor_synthetic_data') }}

    with source as (
        select 
        participant_id,
        consent_code,
        CASE phenotype.onset_age_range
            WHEN 'NA' THEN NULL
            ELSE phenotype.onset_age_range
        END::text as "age_at_event",
        REPLACE(term_id, '?', '')::text as "code",
        CASE 
            WHEN LOWER(phenotype.presence) = 'present' THEN 'LA9633-4'
            WHEN LOWER(phenotype.presence) = 'absent' THEN 'LA9634-2'
            WHEN phenotype.presence is null THEN 'LA4489-6'
            ELSE CONCAT('FTD_FLAG: unhandled value_code: ', presence)
        END::text as "value_code",
        CASE 
            WHEN LOWER(phenotype.presence) = 'absent' THEN 'Absent'
            WHEN LOWER(phenotype.presence) = 'present' THEN 'Present'
            WHEN phenotype.presence IS NULL THEN 'Unknown'
            ELSE CONCAT('FTD_FLAG: unhandled value_display: ', presence)
        END::text as "value_display",
        participant.age_at_enrollment::text as "value_number"
        from {{ ref('gregor_synthetic_stg_participant') }} as participant
        join {{ ref('gregor_synthetic_stg_phenotype') }} as phenotype
        using(participant_id) 
    )

        select distinct
        'phenotypic_feature'::text as "assertion_type",
        NULL::text as "age_at_assertion",
        age_at_event,
        NULL::text as "age_at_resolution",
        ga.response_code as "code",
        ga.display as "display",
        value_code,
        value_display,
        value_number,
        NULL::text as "value_units",
        NULL::text as "value_units_display",
       {{ generate_global_id(prefix='ap',descriptor=['consent_code'], study_id='gregor_synthetic') }}::text as "has_access_policy",
       {{ generate_global_id(prefix='sb',descriptor=['participant_id', 'consent_code'], study_id='gregor_synthetic') }}::text as "Subject_id",
       {{ generate_global_id(prefix='sa',descriptor=['participant_id', 'code'], study_id='gregor_synthetic') }}::text as "id"
       from source as s
       left join {{ ref('gregor_synthetic_annotations') }} as ga
       on lower(s.code) = lower(ga.searched_code)