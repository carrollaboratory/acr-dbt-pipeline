{% macro map_cmg_source_concepts(source_relation, mapdragon_relation, uwash_split_relation) %}
select *
from (
with mapping_inputs as (
    select
        source.*,
        case
            when source.text_column is not null
                then source.normalized_text
            else source.normalized_concept
        end as mapping_lookup_value,
        null::text as uwash_mapping_relation,
        null::text as uwash_original_text,
        null::text as uwash_split_text,
        null::boolean as uwash_was_split
    from {{ source_relation }} as source

    union all

    select distinct
        source.source_snapshot,
        source.source_snapshot_id,
        source.source_site,
        source.consent_group,
        source.source_relation,
        source.source_column,
        source.text_column,
        source.concept_column,
        source.raw_text,
        null::text as raw_concept,
        uwash.split_text::text as normalized_text,
        null::text as normalized_concept,
        null::bigint as token_position,
        source.source_datasets,
        uwash.split_text::text as mapping_lookup_value,
        'uwash_split_text_mapping_disease_and_phenotype'::text as uwash_mapping_relation,
        uwash.original_text::text as uwash_original_text,
        uwash.split_text::text as uwash_split_text,
        uwash.was_split as uwash_was_split
    from {{ source_relation }} as source
    inner join {{ uwash_split_relation }} as uwash
        on source.raw_text = uwash.original_text
    where starts_with(source.source_snapshot, 'cmg_uwash_')
        and source.source_column in ('disease_description', 'phenotype_description')
        and source.text_column is not null
        and uwash.split_text is not null
)
select distinct
    source.source_snapshot,
    source.source_snapshot_id,
    source.source_site,
    source.consent_group,
    source.source_relation,
    source.source_column,
    source.text_column,
    source.concept_column,
    source.raw_text,
    source.normalized_text,
    source.raw_concept,
    source.normalized_concept,
    source.token_position,
    source.source_datasets,
    source.mapping_lookup_value,
    source.uwash_mapping_relation,
    source.uwash_original_text,
    source.uwash_split_text,
    source.uwash_was_split,
    case
        when mapping.source_system is not null then 'mapdragon_annotations_talon'
    end as mapping_relation,
    mapping.source_system as mapping_source_system,
    mapping.source_text as mapping_source_text,
    mapping.mapped_code,
    mapping.mapped_display,
    mapping.mapped_system,
    mapping.table_id as mapping_table_id
from mapping_inputs as source
left join (
    select
        case source_system
            when 'https://anvilproject.org//disease_description' then 'disease_description'
            when 'https://anvilproject.org//phenotype_description' then 'phenotype_description'
            when 'https://anvilproject.org//hpo_present' then 'hpo_present'
            when 'https://anvilproject.org//hpo_absent' then 'hpo_absent'
        end as source_column,
        table_id::text as table_id,
        source_text::text as source_text,
        source_system::text as source_system,
        mapped_code::text as mapped_code,
        mapped_display::text as mapped_display,
        mapped_system::text as mapped_system
    from {{ mapdragon_relation }}
    where source_system in (
        'https://anvilproject.org//disease_description',
        'https://anvilproject.org//phenotype_description',
        'https://anvilproject.org//hpo_present',
        'https://anvilproject.org//hpo_absent'
    )
) as mapping
    on mapping.source_column = source.source_column
    and mapping.source_text = source.mapping_lookup_value
) as mapped
{% endmacro %}
