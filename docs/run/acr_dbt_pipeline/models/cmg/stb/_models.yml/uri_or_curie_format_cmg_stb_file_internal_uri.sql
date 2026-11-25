
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

select internal_uri as value_to_check
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_file"
where internal_uri is not null
  and not 
    regexp_matches(cast(internal_uri as TEXT), '^([a-z][a-z0-9+.-]*://[^\s/][^\s]*|urn:[^\s]+)$')

  and not 
    regexp_matches(cast(internal_uri as TEXT), '^[A-Za-z_][A-Za-z0-9_.-]*:[^\s/][^\s]*$')



  
  
      
    ) dbt_internal_test