
    
    

select
    id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_investigator"
where id is not null
group by id
having count(*) > 1


