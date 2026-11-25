

select concept_curie as value_to_check
from "acr_dbt_pipeline"."main_cmg"."cmg_int_concepts"
where concept_curie is not null
  and not 
    regexp_matches(cast(concept_curie as TEXT), '^[A-Za-z_][A-Za-z0-9_.-]*:[^\s/][^\s]*$')


