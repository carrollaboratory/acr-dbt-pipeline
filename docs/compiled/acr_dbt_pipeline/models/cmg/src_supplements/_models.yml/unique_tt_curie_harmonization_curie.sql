
    
    

select
    curie as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."tt_curie_harmonization"
where curie is not null
group by curie
having count(*) > 1


