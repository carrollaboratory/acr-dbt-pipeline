
    
    

select
    sample_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_sample"
where sample_id is not null
group by sample_id
having count(*) > 1


