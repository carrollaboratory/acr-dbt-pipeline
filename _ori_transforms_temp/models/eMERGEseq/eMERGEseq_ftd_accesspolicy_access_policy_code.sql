{{ config(materialized='table', schema='eMERGEseq_data') }}

    with source as (
        select DISTINCT
        {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "accesspolicy_id",
       'gru' as "access_policy_code"
        from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
          WHERE subjectconsent.consent IN ('1', '3', '4', '5', '9')

    UNION ALL
        
    select DISTINCT
        {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "accesspolicy_id",
        'irb' as "access_policy_code"
    from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
    WHERE subjectconsent.consent IN ('3', '4', '5', '10')

    UNION ALL
        
    select DISTINCT
        {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "accesspolicy_id",
        'npu' as "access_policy_code"
    from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
    WHERE subjectconsent.consent IN ('4', '5', '8', '9')

     UNION ALL
        
    select DISTINCT
        {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "accesspolicy_id",
        'pub' as "access_policy_code"
    from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
    WHERE subjectconsent.consent IN ('5', '10')
    
    UNION ALL
        
    select DISTINCT
        {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "accesspolicy_id",
        'hmb' as "access_policy_code"
    from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
    WHERE subjectconsent.consent IN ('6', '7', '8', '10')

    UNION ALL
        
    select DISTINCT
        {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "accesspolicy_id",
        'gso' as "access_policy_code"
    from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
    WHERE subjectconsent.consent IN ('7')
    )

    select 
        * 
    from source
    
    
    