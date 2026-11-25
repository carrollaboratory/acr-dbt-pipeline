
    
    

select
    family_membership_id as unique_field,
    count(*) as n_records

from "acr_dbt_pipeline"."main_cmg"."cmg_stb_familymembership"
where family_membership_id is not null
group by family_membership_id
having count(*) > 1


