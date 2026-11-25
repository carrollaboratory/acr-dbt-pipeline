
    
    

with child as (
    select "target_concept_curie" as from_field
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_conceptrelationship"
    where "target_concept_curie" is not null
),

parent as (
    select "concept_curie" as to_field
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_concept"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


