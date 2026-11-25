
    
    

select
    concept_curie as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_concept"
where concept_curie is not null
group by concept_curie
having count(*) > 1


