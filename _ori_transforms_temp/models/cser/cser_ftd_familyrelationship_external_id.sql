{{ config(materialized='table', schema='cser_data') }}

with source as (
        select DISTINCT
        subject_id AS other_family_member, 
        paternal_id AS subject_id,
        'KIN:028' AS relationship_code,
        family_id
        from {{ ref('cser_stg_subject') }} as subject WHERE paternal_id is not null

        UNION 

        select DISTINCT
        subject_id AS other_family_member, 
        maternal_id AS subject_id,
        'KIN:027' AS relationship_code,
         family_id
        from {{ ref('cser_stg_subject') }} as subject WHERE maternal_id is not null
     
        UNION 
        select DISTINCT        
        maternal_id AS other_family_member, 
        subject_id,
        'KIN:032' AS relationship_code,
         family_id
        from {{ ref('cser_stg_subject') }} as subject WHERE maternal_id is not null
     
        UNION 
        select DISTINCT        
        paternal_id AS other_family_member, 
        subject_id,
        'KIN:032' AS relationship_code,
         family_id
        from {{ ref('cser_stg_subject') }} as subject WHERE paternal_id is not null
    )

select distinct
  {{ generate_global_id(prefix='fr',descriptor=['family_id','subject_id','other_family_member', 'relationship_code'], study_id='cser') }}::text as "familyrelationship_id",
  subject_id::text as "external_id"
from source

