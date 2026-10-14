{{ config(materialized='table', schema='eMERGEseq_data') }}

    with source as (
        select 
        GEN_UNKNOWN.availablity_status::text as "availablity_status",
       GEN_UNKNOWN.quantity_number::text as "quantity_number",
       GEN_UNKNOWN.quantity_units::text as "quantity_units",
       GEN_UNKNOWN.concentration_number::text as "concentration_number",
       GEN_UNKNOWN.concentration_unit::text as "concentration_unit",
       {{ generate_global_id(prefix='',descriptor=[''], study_id='eMERGEseq') }}::text as "has_access_policy",
       {{ generate_global_id(prefix='',descriptor=[''], study_id='eMERGEseq') }}::text as "id",
       {{ generate_global_id(prefix='',descriptor=[''], study_id='eMERGEseq') }}::text as "sample_id"
        from {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
        join {{ ref('eMERGEseq_stg_demographics') }} as demographics
on subjectconsent.subject_id = demographics.subject_id  join {{ ref('eMERGEseq_stg_phecode') }} as phecode
on   join {{ ref('eMERGEseq_stg_samplesubjectmapping') }} as samplesubjectmapping
on   join {{ ref('eMERGEseq_stg_sampleattributes') }} as sampleattributes
on  
    )

    select 
        * 
    from source
    