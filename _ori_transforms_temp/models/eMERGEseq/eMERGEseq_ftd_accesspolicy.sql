{{ config(materialized='table', schema='eMERGEseq_data') }}

    with source as (
     select DISTINCT
         NULL as "disease_limitation",
         'General Research Use' as "description",
         NULL as "website",
        {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "id"
    from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
  WHERE subjectconsent.consent IN ('1', '3', '4', '5', '9')

    UNION ALL
        
    select DISTINCT
         NULL as "disease_limitation",
        'IRB Approval Required' as "description",
         NULL as "website",
        {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "id"
    from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
    WHERE subjectconsent.consent IN ('3', '4', '5', '10')

    UNION ALL
        
    select DISTINCT
         NULL as "disease_limitation",
        'Not-for-profit use only' as "description",
         NULL as "website",
        {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "id"
    from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
    WHERE subjectconsent.consent IN ('4', '5', '8', '9')

     UNION ALL
        
    select DISTINCT
         NULL as "disease_limitation",
        'Publication Required' as "description",
         NULL as "website",
        {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "id"
    from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
    WHERE subjectconsent.consent IN ('5', '10')
    
    UNION ALL
        
    select DISTINCT
         NULL as "disease_limitation",
        'Health/Medical/Biomedical' as "description",
         NULL as "website",
        {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "id"
    from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
    WHERE subjectconsent.consent IN ('6', '7', '8', '10')

    UNION ALL
        
    select DISTINCT
        NULL as "disease_limitation",
        'Genetic Studies only' as "description",
        NULL as "website",
        {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "id"
    from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
    WHERE subjectconsent.consent IN ('7')
    )
    select 
        * 
    from source
    