# generate_global_id_descriptor_view_sql Quickstart

Use this macro to map the FHIR resources that kf-etl-dbt-dewrangle builds from
the dewrangle models (`models/kids_first/dataservice/dewrangle`) to their
Dewrangle global IDs and descriptors, for every study at once.

## Basic Usage

Every resource, with its global ID and descriptor:

```jinja
{{ config(materialized='table') }}

{{ generate_global_id_descriptor_view_sql(
    table_prefix='kf_ds_dewrangle_'
) }}
```

Only the global IDs already minted in Dewrangle, as a descriptor update file:

```jinja
{{ config(materialized='view') }}

{{ generate_global_id_descriptor_view_sql(
    table_prefix='kf_ds_dewrangle_',
    gid_lookup=source('kf_dewrangle', 'kf_globalids')
) }}
```

## Arguments

- table_prefix: prefix used to resolve the dewrangle models
- gid_lookup: the Dewrangle global ID export (relation or model name). Optional

## Output

- `study_id`: KF ID of the study (null for sequencing centers, which are
  shared by all studies)
- `fhir_entity`: the kf-etl-dbt-dewrangle FHIR entity builder
- `fhirResourceType`, `globalId`, `descriptor`
- `kf_id`: the kf id the global ID was minted from
- with gid_lookup: `descriptorState`, `current_descriptor` (the descriptor in
  Dewrangle) and `descriptor_changed`

## Adding a FHIR entity

Add an entry to `descriptor_sources` with the entity's model
(`relation_name`), descriptor column, global ID column and kf id column. The
model must have `study_id` unless the entry sets `study_scoped: false`.
