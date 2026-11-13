
  
  create view "acr_dbt_pipeline"."main_cmg"."cmg_stb_hashdigest__dbt_tmp" as (
    select
    id::integer as "id",
    hash_type::text as "hash_type",
    hash_value::text as "hash_value"
  );
