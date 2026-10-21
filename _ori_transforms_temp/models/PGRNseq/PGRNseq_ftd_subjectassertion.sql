{{ config(materialized='table', schema='PGRNseq_data') }}

{% set bmi_relation = ref('PGRNseq_stg_bmi') %}
{% set bmi_constant_columns = ['ftd_index', 'subject_id', 'age_observation', 'visit_number'] %}
{% set bmi_pivot_columns = get_columns(relation=bmi_relation, exclude=bmi_constant_columns) %}

{% set ecg_relation = ref('PGRNseq_stg_ecg') %}
{% set ecg_constant_columns = ['ftd_index', 'subject_id', 'age_at_ecg', 'visit_number'] %}
{% set ecg_pivot_columns = get_columns(relation=ecg_relation, exclude=ecg_constant_columns) %}

{% set lab_relation = ref('PGRNseq_stg_labs') %}
{% set lab_constant_columns = ['ftd_index', 'subject_id', 'age_at_lipids', 'visit_number'] %}
{% set lab_pivot_columns = get_columns(relation=lab_relation, exclude=lab_constant_columns) %}

with bmi_cte as (
    {% for col in bmi_pivot_columns %}
        select distinct
        bmi.subject_id,
        bmi.age_observation as age_at_event,
        '{{ col }}' as code,
        NULL as display,
        NULL as value_code,
        NULL as value_display,
        {{ col }}::text as value_number,
        NULL as value_units_display,
        from {{ bmi_relation }} as bmi
        {% if not loop.last %}union all{% endif %}
    {% endfor %}
),

bmi_w_units as (
    select distinct
        bc.*,
        bu.units as value_units
    from bmi_cte as bc
    left join {{ ref('bmi_seed') }} as bu
        on bc.code = bu.variable_name
),

ecg_cte as (
    {% for col in ecg_pivot_columns %}
        select distinct
        ecg.subject_id,
        ecg.age_at_ecg as age_at_event,
        '{{ col }}' as code,
        NULL as display,
        NULL as value_code,
        NULL as value_display,
        {{ col }}::text as value_number,
        NULL as value_units_display
        from {{ ecg_relation }} as ecg
        {% if not loop.last %}union all{% endif %}
    {% endfor %}
),

ecg_w_units as (
    select distinct
        ec.*,
        eu.units as value_units
    from ecg_cte as ec
    left join {{ ref('ecg_seed') }} as eu
        on ec.code = eu.variable_name
),

lab_cte as (
    {% for col in lab_pivot_columns %}
        select distinct
        lab.subject_id,
        lab.age_at_lipids as age_at_event,
        '{{ col }}' as code,
        NULL as display,
        NULL as value_code,
        NULL as value_display,
        {{ col }}::text as value_number,
        NULL as value_units_display
        from {{ lab_relation }} as lab
        {% if not loop.last %}union all{% endif %}
    {% endfor %}
),

lab_w_units as (
    select distinct
        lc.*,
        lu.units as value_units
    from lab_cte as lc
    left join {{ ref('labs_seed') }} as lu
        on lc.code = lu.variable_name
),

union_data as (
    select * from bmi_w_units
    union all
    select * from ecg_w_units
    union all
    select * from lab_w_units
)

select distinct
    'measurement' AS assertion_type,
    NULL as age_at_assertion,
    age_at_event, 
    NULL as age_at_resolution,
    CASE 
        WHEN LOWER(cast(mappings."code system" AS VARCHAR)) LIKE '%loinc%' THEN CONCAT('LOINC:', mappings.code)
        ELSE mappings.code
    END as code,        
    mappings.display AS display,
    CASE 
        WHEN mappings.code = 'SNOMED:439631004' THEN
            CASE ud.value_number
                WHEN '0' THEN 'SNOMED:715036001'
                WHEN '1' THEN 'SNOMED:129019007'
                ELSE NULL
            END
        ELSE NULL
    END AS value_code,
    CASE
        WHEN mappings.code = 'SNOMED:439631004' THEN
            CASE ud.value_number
                WHEN 0 THEN 'Does not take medication'
                WHEN 1 THEN 'Taking medication'
                ELSE NULL
            END
        ELSE NULL
    END AS value_display, 
    value_number,
    mappings.value_units AS value_units,  
    CASE 
        WHEN ud.value_units = 'Kilograms' THEN 'kilogram'
        WHEN ud.value_units = 'cm' THEN 'centimeter'
        WHEN ud.value_units = 'kg/m2' THEN 'kilogram per square meter'   
        WHEN ud.value_units = 'ms' THEN 'millisecond'
        WHEN ud.value_units = 'bpm' THEN 'heart beats per minute'
        WHEN ud.value_units = 'mg/dL' THEN 'milligram per deciliter'
        ELSE NULL
    END AS value_units_display,
    {{ generate_global_id(prefix='sa', descriptor=['subject_id', 'mappings.code', 'subjectconsent.consent'], study_id='phs000906') }}::text as id,
    {{ generate_global_id(prefix='ap', descriptor=['subjectconsent.consent'], study_id='phs000906') }}::text as has_access_policy,
    {{ generate_global_id(prefix='sb', descriptor=['subject_id', 'subjectconsent.consent'], study_id='phs000906') }}::text as subject_id
from union_data as ud
left join {{ ref('PGRNseq_stg_subjectconsent') }} as subjectconsent
    using (subject_id)
left join (
    select 
        "local code" as local_code,
        code,
        display,
        "code system",
        value_units
    from {{ ref('bmi_mappings') }}

    union all

    select 
        "local code" as local_code,
        code,
        display,
        "code system",
        value_units
    from {{ ref('labs_mappings') }}

    union all

    select 
        local_code,
        code,
        display,
        "code system",
        value_units
    from {{ ref('ecg_mappings') }}
) as mappings
    on ud.code = mappings.local_code
