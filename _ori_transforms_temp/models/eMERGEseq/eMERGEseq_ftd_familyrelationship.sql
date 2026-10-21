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
                '{{ col }}' as "relationship",
            from {{ ref('eMERGEseq_stg_pedigree') }} as p
            WHERE {{ col }} IS NOT NULL 
            {% if not loop.last %}union all{% endif %}
        {% endfor %}
    ),
    
   direct_relationship as (
   select -- probands on the left, others on the right
       p.ftd_index,
       p.family_id,
       proband_id as "family_member",
       other_family_memb_id as "other_family_member",
       CASE  
           WHEN relationship = 'mother' THEN 'KIN:032'
           WHEN relationship = 'father' THEN 'KIN:032'
           WHEN relationship = 'mz_twin_id' THEN 'KIN:010'
       END::text AS relationship_code
       from {{ ref('eMERGEseq_stg_pedigree') }} as p
    left join unpivot_df as u on u.proband_id = p.subject_id
       and u.family_id = p.family_id
    where mother is not null
    and father is not null
    and mz_twin_id is not null
),
    
   reverse_twin_relationship as (
   select -- reverse relationship for twins
       dr.ftd_index,
       dr.family_id,
       dr.other_family_member as "family_member",
       dr.family_member as "other_family_member",
       dr.relationship_code
    from direct_relationship as dr
    where relationship_code = 'KIN:010'
    )

    select DISTINCT
        {{ generate_global_id(prefix='fr',descriptor=['family_id','family_member','other_family_member','relationship_code'],study_id='phs001616') }}::text as "id",
        relationship_code, 
        {{ generate_global_id(prefix='sb',descriptor=['family_member'], study_id='phs001616') }}::text AS "family_member",
        {{ generate_global_id(prefix='sb',descriptor=['other_family_member'], study_id='phs001616') }}::text as "other_family_member",
        {{ generate_global_id(prefix='ap',descriptor=['subjectconsent.consent'], study_id='phs001616') }}::text as "has_access_policy"

    from (
        select distinct * from direct_relationship 
    
    union all
    
        select distinct * from reverse_twin_relationship) as combined_relationship
    left join {{ ref('eMERGEseq_stg_subjectconsent') }} as subjectconsent
    on subjectconsent.subject_id = combined_relationship.family_member