
    
    

select
    file_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_file"
where file_id is not null
group by file_id
having count(*) > 1


