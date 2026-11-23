with base as (
  select
    normalized_concept as curie,
    NULL as prefix
  from {{ ref('cmg_int_source_concepts') }}
  where normalized_concept is not null
  order by normalized_concept
)

,split_alias as (
  select UNNEST(string_split(synonym, ',')) as viable_ontos
  from {{ ref('vocabulary_details') }}
)

select distinct
    curie,
    case 
        when viable_ontos is not null then viable_ontos
        when starts_with(curie, 'MTH') then 'OMIM'
        when starts_with(curie, 'PS') then 'OMIM'
        else null
    end as prefix
from base
left join split_alias 
    on starts_with(curie, viable_ontos)
order by prefix, curie