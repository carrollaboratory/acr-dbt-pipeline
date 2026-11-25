
    
    

select
    dataset_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_dataset"
where dataset_id is not null
group by dataset_id
having count(*) > 1


