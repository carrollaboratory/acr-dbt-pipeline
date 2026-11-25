
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_stb_concept__dbt_tmp"
  
    
    as (
      

select
    concept_curie::text as concept_curie,
    concept_id,
    vocabulary_prefix::text as vocabulary_prefix,
    concept_code::text as concept_code,
    display::text as display,
    definition::text as definition
from "acr_dbt_pipeline"."main_cmg"."cmg_int_concepts"
    );
    
  