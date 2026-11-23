
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_stb_demographics_race__dbt_tmp"
  
    
    as (
      select distinct
    subject_gid::text as "demographics_subject_id",
    ancestry_mapped_code::text as "race_concept_curie"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_subject"
where subject_id is not null
and ancestry_mapped_code is not null
and not regexp_full_match(trim(ancestry_mapped_code), '(?i:CDCREC:)?(2135-2|2186-5)')
    );
    
  