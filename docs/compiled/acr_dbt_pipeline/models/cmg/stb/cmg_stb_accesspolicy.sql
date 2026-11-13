select
  'co' || '_' || md5(cast(coalesce(consent_group, '') as text))::text as  "access_policy_id",
  --case
        when nullif(trim(cast( as TEXT)), '') is null then null
        when nullif(trim(cast( as TEXT)), '') like '%://%' or lower(nullif(trim(cast( as TEXT)), '')) like 'urn:%' then nullif(trim(cast( as TEXT)), '')
        when not (nullif(trim(cast( as TEXT)), '') like '%:%') then nullif(trim(cast( as TEXT)), '')
        else coalesce(
            (
                select max(p.prefix)
                from "acr_dbt_pipeline"."main"."vocabulary_details" as p
                where lower(p.prefix) = lower(trim(split_part(nullif(trim(cast( as TEXT)), ''), ':', 1)))
                   or lower(p.alias_prefix) = lower(trim(split_part(nullif(trim(cast( as TEXT)), ''), ':', 1)))
            ),
            trim(split_part(nullif(trim(cast( as TEXT)), ''), ':', 1))
        ) || ':' || trim(substr(nullif(trim(cast( as TEXT)), ''), strpos(nullif(trim(cast( as TEXT)), ''), ':') + 1))
    end
::text as "data_use_accession",
    data_use_permission::text as "data_use_permission",
    data_use_modifier::text as "data_use_modifier",
    disease_limitation::text as "disease_limitation",
    access_description::text as "access_description",
    website::text as "website"