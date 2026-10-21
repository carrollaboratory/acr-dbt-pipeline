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
        description as display
    from {{ ref('phecode_seed') }}),

     
unpivot_df as (

    {% for col in condition_columns %}
        select
            {{ constant_columns | join(', ') }},
            NULL as "age_at_event",
            '{{ col }}' as code,
            case when "{{ col }}" = 0 then 'LA9634-2'
                 when "{{ col }}" = 1 then 'LA9633-4'
            end as value_code,
            case when "{{ col }}" = 0 then 'Absent'
                 when "{{ col }}" = 1 then 'Present'
            end as value_display,
            NULL as "value_number",
        from {{ ref('eMERGEseq_stg_phecode') }} as p
        {% if not loop.last %}union all{% endif %}
    {% endfor %}
),

unpivoted_with_display as (
    select distinct
        up.*,
        lookup.display as 'display'
    from unpivot_df as up
    left join lookup
        on up.code = lookup.code
),

unpivot_bmi as (

        {% for col in pivot_bmi_columns %}
            select distinct
            subject_id, ftd_index,
            bmi.age_at_observation::text as "age_at_event",
            '{{ col }}' AS "code",
            NULL AS "value_code",
            NULL AS "value_display",
           {{ col }}::text as "value_number",
            NULL as "display"
            from {{ ref('eMERGEseq_stg_bmi') }} as bmi
            {% if not loop.last %}union all{% endif %}
        {% endfor %}
    ),
    
union_data as (
    select * from unpivoted_with_display as uwd

    union all 
    
    select * from unpivot_bmi as ub
)

    select distinct 
        CASE WHEN code IN ('weight', 'height', 'body_mass_index') THEN 'measurement' 
             WHEN UPPER(code) LIKE 'PHE%' THEN 'ehr_billing_code'
             ELSE CONCAT('FTD_FLAG: unhandled assertion_type: ',code)
        END::text as "assertion_type",
        null as "age_at_assertion",
        age_at_event, 
        null as "age_at_resolution",
        CASE 
            WHEN code = 'weight'THEN 'LOINC:29463-7'
            WHEN code = 'height' THEN 'LOINC:8302-2'
            WHEN code = 'body_mass_index' THEN 'LOINC:39156-5'
            ELSE code
        END AS code,        
        CASE 
            WHEN code = 'weight' THEN 'Body weight'
            WHEN code = 'height' THEN 'Body height'
            WHEN code = 'body_mass_index' THEN 'Body mass index (BMI) [Ratio]' 
            ELSE display
        END AS display,
        value_code, 
        value_display, 
        value_number,
        CASE 
            WHEN code = 'weight' THEN 'kg'
            WHEN code = 'height' THEN 'cm'
            WHEN code = 'body_mass_index' THEN 'kg/m2'   
            ELSE NULL
        END AS "value_units",  
        CASE 
            WHEN code = 'weight' THEN 'kilogram'
            WHEN code = 'height' THEN 'centimeter'
            WHEN code = 'body_mass_index' THEN 'kilogram per square meter'   
            ELSE NULL
        END as "value_units_display",
        {{ generate_global_id(prefix='sa', descriptor=['subject_id', 'code'], study_id='phs001616') }}::text as "id",
        {{ generate_global_id(prefix='ap', descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "has_access_policy",
        {{ generate_global_id(prefix='sb', descriptor=['subject_id'], study_id='phs001616') }}::text as "subject_id"
    from union_data as ud
    left join {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
         using (subject_id)