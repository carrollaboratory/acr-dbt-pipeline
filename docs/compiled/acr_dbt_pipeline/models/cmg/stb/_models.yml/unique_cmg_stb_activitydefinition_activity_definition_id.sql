
    
    

select
    activity_definition_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_activitydefinition"
where activity_definition_id is not null
group by activity_definition_id
having count(*) > 1


