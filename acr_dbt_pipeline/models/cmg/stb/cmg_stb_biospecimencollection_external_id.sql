{{ config(materialized='table') }}

select
  null::text as "biospecimencollection_biospecimen_collection_id",
  null::text as "external_id"
where 1 = 0
