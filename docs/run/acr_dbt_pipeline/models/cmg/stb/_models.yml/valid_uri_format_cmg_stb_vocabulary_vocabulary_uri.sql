
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

select vocabulary_uri as value_to_check
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_vocabulary"
where vocabulary_uri is not null
  and not 
    regexp_matches(cast(vocabulary_uri as TEXT), '^([a-z][a-z0-9+.-]*://[^\s/][^\s]*|urn:[^\s]+)$')



  
  
      
    ) dbt_internal_test