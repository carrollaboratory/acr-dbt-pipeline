{{ config(materialized='table', schema='eMERGEseq_data') }}
    {% set relation = ref('eMERGEseq_stg_pedigree') %}
    {% set constant_columns = ['ftd_index', 'sex', 'subject_id', 'family_id'] %}
    {% set pivot_columns = get_columns(relation=relation, exclude=constant_columns) %}  
    
    with 
    unpivot_df as (

        {% for col in pivot_columns %}
            select
                ftd_index, family_id,
                {{ col }} as "other_family_memb_id",
                subject_id as "proband_id",
                NULL as "sex",
                '{{ col }}' as "family_role",
            from {{ ref('eMERGEseq_stg_pedigree') }} as p
            WHERE {{ col }} IS NOT NULL 
            {% if not loop.last %}union all{% endif %}
        {% endfor %}
    ),
    
   all_pedigree as (
   select distinct -- probands only
        ftd_index,
        family_id,
        subject_id as "proband_id",
        subject_id,
        null as "other_family_memb_id",
        mother,
        father,
        mz_twin_id,
        p.sex,
        'CHILD' as "family_role",
    from {{ ref('eMERGEseq_stg_pedigree') }} as p
    where mother is not null
    and father is not null
    and mz_twin_id is not null
 union all
    select distinct -- mothers/fathers only
        p.ftd_index,
        p.family_id,
        proband_id,
        other_family_memb_id AS "subject_id",
        other_family_memb_id,
        NULL AS mother,
        NULL AS father,
        NULL AS mz_twin_id,
        p.sex,
        CASE p.sex
           WHEN 2 then 'MTH' 
           WHEN 1 THEN 'FTH'
        END::text as "family_role"
    from {{ ref('eMERGEseq_stg_pedigree') }} as p
    left join unpivot_df as u on u.proband_id = p.subject_id
              and u.family_id = p.family_id
    where mother is null
    and father is null
    and mz_twin_id is null
),
        source as(
        select distinct
        {{ generate_global_id(prefix='sb',descriptor=['subjectconsent.subject_id'], study_id='phs001616') }}::text as "family_member",
       family_role,
       {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "has_access_policy",
       {{ generate_global_id(prefix='fm',descriptor=['pedigree.subject_id', 'pedigree.family_id'], study_id='phs001616') }}::text as "id",
       {{ generate_global_id(prefix='fy',descriptor=['pedigree.family_id'], study_id='phs001616') }}::text as "family_id"
       from all_pedigree as pedigree
       left join {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
        on pedigree.subject_id = subjectconsent.subject_id
    )

    select 
        * 
    from source
    