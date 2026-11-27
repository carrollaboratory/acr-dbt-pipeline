with base as (
  select normalized_concept as curie
  from {{ ref('cmg_int_source_concepts') }}

  union

  select data_use_permission_duo_code as curie
  from {{ ref('cmg_int_anvil_dataset') }}

  union

  select data_use_modifier_duo_codes as curie
  from {{ ref('cmg_int_anvil_dataset') }}

  union

  select enumeration_code as curie
  from {{ ref('model_enums') }}

  union

  select concept_curie as curie
  from {{ ref('hardcoded_concepts') }}
)

select distinct
    curie,
    case
        when {{ regex_match('curie', uri_curie_patterns()['curie']) }}
          then split_part(curie, ':', 1)
        when starts_with(curie, 'MTH') then 'OMIM'
        when starts_with(curie, 'PS') then 'OMIM'
        when curie in ('1002-5','2131-1', '2028-9', '2076-8', '2106-3', '2054-5', '2135-2') THEN 'CDCREC'
        else null
    end as prefix
from base
where curie is not null
order by prefix, curie