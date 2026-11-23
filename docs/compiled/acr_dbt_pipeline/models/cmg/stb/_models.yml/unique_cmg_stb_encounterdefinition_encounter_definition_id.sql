
    
    

select
    encounter_definition_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_encounterdefinition"
where encounter_definition_id is not null
group by encounter_definition_id
having count(*) > 1


