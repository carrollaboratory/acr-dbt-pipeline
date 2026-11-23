
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_stb_subjectassertion_concept__dbt_tmp"
  
    
    as (
      

select
    assertion_id::text as "subjectassertion_assertion_id",
    concept_curie::text as "concept_concept_curie"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject_assertions"
where concept_curie is not null
    );
    
  