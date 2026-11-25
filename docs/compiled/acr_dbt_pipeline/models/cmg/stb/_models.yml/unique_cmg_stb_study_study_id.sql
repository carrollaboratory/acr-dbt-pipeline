
    
    

select
    study_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_study"
where study_id is not null
group by study_id
having count(*) > 1


