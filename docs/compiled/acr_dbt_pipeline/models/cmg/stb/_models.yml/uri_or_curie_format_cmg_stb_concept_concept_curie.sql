

select concept_curie as value_to_check
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_concept"
where concept_curie is not null
  and not 
    regexp_matches(cast(concept_curie as TEXT), '^([a-z][a-z0-9+.-]*://[^\s/][^\s]*|urn:[^\s]+)$')

  and not 
    regexp_matches(cast(concept_curie as TEXT), '^[A-Za-z_][A-Za-z0-9_.-]*:[^\s/][^\s]*$')


