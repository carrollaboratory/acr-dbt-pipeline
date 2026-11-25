
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

select fhir_system as value_to_check
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_vocabulary"
where fhir_system is not null
  and not 
    regexp_matches(cast(fhir_system as TEXT), '^([a-z][a-z0-9+.-]*://[^\s/][^\s]*|urn:[^\s]+)$')



  
  
      
    ) dbt_internal_test