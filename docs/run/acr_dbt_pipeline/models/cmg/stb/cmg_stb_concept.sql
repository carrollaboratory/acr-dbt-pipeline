
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_stb_concept__dbt_tmp"
  
    
    as (
      

select *
from "acr_dbt_pipeline"."main_cmg"."tt_concepts"
    );
    
  