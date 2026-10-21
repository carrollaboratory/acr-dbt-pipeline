{{ config(materialized='table', schema='GREGoR_R03_GRU_20250612_data') }}

    with source as (
        select DISTINCT
        NULL as "disease_limitation",
        CASE UPPER(participant.consent_code)
            WHEN 'GRU' THEN 'General Research Use'
            WHEN 'HMB' THEN 'Health/Medical/Biomedical'
            WHEN 'DS' THEN 'Disease-Specific (Disease/Trait/Exposure)'
            WHEN 'IRB' THEN 'IRB Approval Required'
            WHEN 'PUB' THEN 'Publication Required'
            WHEN 'COL' THEN 'Collaboration Required'
            WHEN 'NPU' THEN 'Not-for-profit use only'
            WHEN 'MDS' THEN 'Methods'
            WHEN 'GSO' THEN 'Genetic Studies only'
            WHEN 'GSR' THEN 'Genomic Summary Results'
        END::text as "description",    
        NULL as "website",
      {{ generate_global_id(prefix='ap',descriptor=['participant.consent_code'], study_id='phs003047') }}::text as "id"
        from {{ ref('GREGoR_R03_GRU_20250612_stg_participant') }} as participant
    )

    select 
        * 
    from source
    