with source_context as (
    select distinct
        s.source_snapshot::text as source_snapshot,
        s.source_snapshot_id::text as source_snapshot_id,
        concat('cmg_', split_part(s.source_snapshot, '_', 2))::text as source_site,
        ad.consent_group::text as consent_group,
        s.disease_description::text as disease_description,
        s.disease_id::text as disease_id,
        s.phenotype_description::text as phenotype_description,
        s.hpo_present::text as hpo_present
    from "acr_dbt_pipeline"."main_cmg"."cmg_main_subject" s
    left join "acr_dbt_pipeline"."main_cmg"."cmg_int_anvil_dataset" ad
        using (source_snapshot_id)
),
source_values as (
    select distinct
        source_snapshot,
        source_snapshot_id,
        source_site,
        consent_group,
        'cmg_main_subject'::text as source_relation,
        'disease_description'::text as source_column,
        'disease_description'::text as text_column,
        'disease_id'::text as concept_column,
        disease_description as raw_text,
        disease_id as raw_concept
    from source_context
    where disease_description is not null or disease_id is not null

    union all

    select distinct
        source_snapshot,
        source_snapshot_id,
        source_site,
        consent_group,
        'cmg_main_subject'::text as source_relation,
        'phenotype_description'::text as source_column,
        'phenotype_description'::text as text_column,
        null::text as concept_column,
        phenotype_description as raw_text,
        null::text as raw_concept
    from source_context
    where phenotype_description is not null

    union all

    select distinct
        source_snapshot,
        source_snapshot_id,
        source_site,
        consent_group,
        'cmg_main_subject'::text as source_relation,
        'hpo_present'::text as source_column,
        null::text as text_column,
        'hpo_present'::text as concept_column,
        null::text as raw_text,
        hpo_present as raw_concept
    from source_context
    where hpo_present is not null
),
source_concepts as (
    select distinct
        source.source_snapshot,
        source.source_snapshot_id,
        source.source_site,
        source.consent_group,
        source.source_relation,
        source.source_column,
        concept.text_column,
        concept.concept_column,
        concept.raw_text,
        concept.raw_concept,
        concept.normalized_text,
        concept.normalized_concept,
        concept.token_position
    from source_values source
    inner join "acr_dbt_pipeline"."main_cmg"."cmg_int_source_concepts" concept
        on concept.text_column is not distinct from source.text_column
        and concept.concept_column is not distinct from source.concept_column
        and concept.raw_text is not distinct from source.raw_text
        and concept.raw_concept is not distinct from source.raw_concept
)


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
    from source_concepts as source

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
        uwash.split_text::text as mapping_lookup_value,
        'uwash_split_text_mapping_disease_and_phenotype'::text as uwash_mapping_relation,
        uwash.original_text::text as uwash_original_text,
        uwash.split_text::text as uwash_split_text,
        uwash.was_split as uwash_was_split
    from source_concepts as source
    inner join "acr_dbt_pipeline"."main_cmg"."uwash_split_text_mapping_disease_and_phenotype" as uwash
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
    from "acr_dbt_pipeline"."main_cmg"."mapdragon_annotations_talon"
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
