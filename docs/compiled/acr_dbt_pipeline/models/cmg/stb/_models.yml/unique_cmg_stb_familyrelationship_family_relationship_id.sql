
    
    

select
    family_relationship_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_familyrelationship"
where family_relationship_id is not null
group by family_relationship_id
having count(*) > 1


