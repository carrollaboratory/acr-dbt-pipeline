
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

select family_study_focus as value_to_check
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_family"
where family_study_focus is not null
  and not 
    regexp_matches(cast(family_study_focus as TEXT), '^([a-z][a-z0-9+.-]*://[^\s/][^\s]*|urn:[^\s]+)$')

  and not 
    regexp_matches(cast(family_study_focus as TEXT), '^[A-Za-z_][A-Za-z0-9_.-]*:[^\s/][^\s]*$')



  
  
      
    ) dbt_internal_test