
    

    create  table
      "acr_dbt_pipeline"."main_cmg"."cmg_stb_accesspolicy__dbt_tmp"
  
    
    as (
      -- one row per study + consent group
select distinct
    access_policy_gid::text as "access_policy_id",
    case
        when nullif(trim(cast(registered_identifier as TEXT)), '') is null then null
        when nullif(trim(cast(registered_identifier as TEXT)), '') like '%://%' or lower(nullif(trim(cast(registered_identifier as TEXT)), '')) like 'urn:%' then nullif(trim(cast(registered_identifier as TEXT)), '')
        when not (nullif(trim(cast(registered_identifier as TEXT)), '') like '%:%') and not 
    regexp_matches(cast(nullif(trim(cast(registered_identifier as TEXT)), '') as TEXT), '^phs[0-9]{6}([.]v[0-9]+[.]p[0-9]+)?$')
 then nullif(trim(cast(registered_identifier as TEXT)), '')
        else coalesce(
            (
                select max(p.prefix)
                from "acr_dbt_pipeline"."main"."vocabulary_details" as p
                where lower(p.prefix) = lower(case when nullif(trim(cast(registered_identifier as TEXT)), '') like '%:%' then trim(split_part(nullif(trim(cast(registered_identifier as TEXT)), ''), ':', 1)) else 'dbgap' end)
                   or lower(p.synonym) = lower(case when nullif(trim(cast(registered_identifier as TEXT)), '') like '%:%' then trim(split_part(nullif(trim(cast(registered_identifier as TEXT)), ''), ':', 1)) else 'dbgap' end)
            ),
            case when nullif(trim(cast(registered_identifier as TEXT)), '') like '%:%' then trim(split_part(nullif(trim(cast(registered_identifier as TEXT)), ''), ':', 1)) else 'dbgap' end
        ) || ':' || case when nullif(trim(cast(registered_identifier as TEXT)), '') like '%:%' then trim(substr(nullif(trim(cast(registered_identifier as TEXT)), ''), strpos(nullif(trim(cast(registered_identifier as TEXT)), ''), ':') + 1)) else nullif(trim(cast(registered_identifier as TEXT)), '') end
    end
::text as "data_use_accession",
    data_use_permission_concept_curie::text as "data_use_permission",
    data_use_modifier_concept_curie::text as "data_use_modifier",
    disease_limitation::text as "disease_limitation",
    cast(null as text) as "access_description",
    cast(null as text) as "website"
from "acr_dbt_pipeline"."main_cmg"."cmg_int_anvil_dataset"
where access_policy_gid is not null
    );
    
  