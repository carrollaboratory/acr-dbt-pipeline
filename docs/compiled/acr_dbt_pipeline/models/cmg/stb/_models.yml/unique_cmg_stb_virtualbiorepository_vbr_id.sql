
    
    

select
    vbr_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_virtualbiorepository"
where vbr_id is not null
group by vbr_id
having count(*) > 1


