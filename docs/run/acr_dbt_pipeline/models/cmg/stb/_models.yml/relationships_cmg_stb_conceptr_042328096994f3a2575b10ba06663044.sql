
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select "concept_curie" as from_field
    from "acr_dbt_pipeline"."main_cmg"."cmg_stb_conceptrelationship"
    where "concept_curie" is not null
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



  
  
      
    ) dbt_internal_test