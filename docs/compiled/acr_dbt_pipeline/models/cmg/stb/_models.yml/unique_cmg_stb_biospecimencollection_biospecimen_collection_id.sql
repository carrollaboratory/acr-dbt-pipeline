
    
    

select
    biospecimen_collection_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_biospecimencollection"
where biospecimen_collection_id is not null
group by biospecimen_collection_id
having count(*) > 1


