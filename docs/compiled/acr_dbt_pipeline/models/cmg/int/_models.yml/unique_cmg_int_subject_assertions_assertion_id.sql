
    
    

select
    assertion_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject_assertions"
where assertion_id is not null
group by assertion_id
having count(*) > 1


