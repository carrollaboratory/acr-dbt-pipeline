

select external_id as value_to_check
from "acr_dbt_pipeline"."main_cmg"."cmg_stb_subject_external_id"
where external_id is not null
  and not 
    regexp_matches(cast(external_id as TEXT), '^([a-z][a-z0-9+.-]*://[^\s/][^\s]*|urn:[^\s]+)$')

  and not 
    regexp_matches(cast(external_id as TEXT), '^[A-Za-z_][A-Za-z0-9_.-]*:[^\s/][^\s]*$')


