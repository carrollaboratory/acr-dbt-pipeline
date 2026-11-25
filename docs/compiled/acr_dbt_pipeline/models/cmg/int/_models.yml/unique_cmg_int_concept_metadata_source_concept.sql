
    
    

select
    source_concept as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_int_concept_metadata"
where source_concept is not null
group by source_concept
having count(*) > 1


