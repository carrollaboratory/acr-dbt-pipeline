
    
    

select
    access_policy_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_accesspolicy"
where access_policy_id is not null
group by access_policy_id
having count(*) > 1


