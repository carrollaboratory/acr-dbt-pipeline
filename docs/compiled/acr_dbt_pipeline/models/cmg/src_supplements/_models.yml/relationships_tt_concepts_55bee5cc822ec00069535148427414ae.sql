
    
    

with child as (
    select vocabulary_prefix as from_field
    from "acr_dbt_pipeline"."main_cmg"."tt_concepts"
    where vocabulary_prefix is not null
),

parent as (
    select vocabulary_prefix as to_field
    from "acr_dbt_pipeline"."main_cmg"."tt_vocabulary"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


