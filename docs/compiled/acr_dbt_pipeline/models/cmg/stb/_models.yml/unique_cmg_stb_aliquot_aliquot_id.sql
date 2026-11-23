
    
    

select
    aliquot_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_aliquot"
where aliquot_id is not null
group by aliquot_id
having count(*) > 1


