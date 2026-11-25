
    
    

select
    person_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_person"
where person_id is not null
group by person_id
having count(*) > 1


