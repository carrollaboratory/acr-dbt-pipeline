
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_stb_study__dbt_tmp"
  
    
    as (
      -- a study(phs) spans several consent groups, so there is no single access policy for it
select distinct
   null::text as "parent_study",
   null::text as "study_title",
   null::text as "study_code",
   null::text as "study_short_name",
   null::text as "study_description",
   null::text as "website",
   null::text as "acknowledgments",
   null::text as "citation_statement",
   null::text as "do_id",
   null::text as "access_policy_id",
    study_gid::text as "study_id"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_anvil_dataset"
where registered_identifier is not null
    );
    
  