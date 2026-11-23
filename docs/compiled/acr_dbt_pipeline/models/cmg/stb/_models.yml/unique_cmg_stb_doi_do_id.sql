
    
    

select
    do_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_doi"
where do_id is not null
group by do_id
having count(*) > 1


