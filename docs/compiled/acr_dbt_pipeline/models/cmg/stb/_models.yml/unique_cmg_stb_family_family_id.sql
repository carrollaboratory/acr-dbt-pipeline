
    
    

select
    family_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_family"
where family_id is not null
group by family_id
having count(*) > 1


