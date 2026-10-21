{{ config(materialized='table', schema='eMERGEseq_data') }}

{% set relation = ref('eMERGEseq_stg_phecode') %}
{% set constant_columns = ['subject_id', 'ftd_index'] %}
{% set condition_columns = get_columns(relation=relation, exclude=constant_columns) %}  

{% set relation_bmi = ref('eMERGEseq_stg_bmi') %}
{% set constant_bmi_columns = ['ftd_index', 'subject_id', 'age_at_observation', 'visit_number'] %}
{% set pivot_bmi_columns = get_columns(relation=relation_bmi, exclude=constant_bmi_columns) %}

with lookup as(
    select 
        LOWER(variable_name) as code, 
    from {{ ref('phecode_seed') }}),

     
unpivot_df as (

    {% for col in condition_columns %}
        select distinct
            {{ constant_columns | join(', ') }},
            '{{ col }}' as code,
        from {{ ref('eMERGEseq_stg_phecode') }} as p
        {% if not loop.last %}union all{% endif %}
    {% endfor %}
),

unpivot_bmi as (

        {% for col in pivot_bmi_columns %}
            select distinct
            subject_id, ftd_index,
            '{{ col }}' AS "code",
            from {{ ref('eMERGEseq_stg_bmi') }} as bmi
            {% if not loop.last %}union all{% endif %}
        {% endfor %}
    ),
    
unpivot_bmi_case as (
    select 
    subject_id, ftd_index,
     CASE 
          WHEN code = 'weight'THEN 'LOINC:29463-7'
          WHEN code = 'height' THEN 'LOINC:8302-2'
          WHEN code = 'body_mass_index' THEN 'LOINC:39156-5'
          ELSE CONCAT('FTD_FLAG: unhandled code: ', code)
     END AS code
    from unpivot_bmi
    ),
    
union_data as (
    select * from unpivot_df as ud

    union all 
    
    select * from unpivot_bmi_case as ubc
)

    select distinct
    {{ generate_global_id(prefix='sa',descriptor=['ud.subject_id', 'ud.code'], study_id='phs001616') }}::text as "subjectassertion_id",
       ud.code::text as "external_id"
        from union_data as ud
    