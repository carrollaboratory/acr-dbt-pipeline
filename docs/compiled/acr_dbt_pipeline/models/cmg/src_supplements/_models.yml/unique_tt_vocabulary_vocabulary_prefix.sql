
    
    

select
    vocabulary_prefix as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."tt_vocabulary"
where vocabulary_prefix is not null
group by vocabulary_prefix
having count(*) > 1


