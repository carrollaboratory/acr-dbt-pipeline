set shell := ["bash", "-cu"]
set export

import "common.just"

default:
    @just -f "{{justfile()}}" --list

help:
    @just -f "{{justfile()}}" --list --unsorted
    @printf '%s\n' '' 'Generation examples:' \
        '  just -f {{file_name(justfile())}} generate-stage <stage>' \
        '  just -f {{file_name(justfile())}} generate-all-stages' \
        '  just -f {{file_name(justfile())}} PIPELINE_STAGES="<stage> ..." generate-all-stages' \
        '  just -f {{file_name(justfile())}} refresh-releases' \
        '' 'Setup, stages, and configuration: utils_README.md'

# Nested profile calls must retain explicit settings rather than reload defaults.
# Only settings defined by the calling profile (exported by `set export`) are
# forwarded, because just rejects overrides for undefined variables.
_stage_args := '
    stage_args=()
    for name in \
        PROGRAM_ID STUDY_ID MODELS_STAGE_ROOT DD_FORMAT SOURCE_SCHEMA \
        SRC_MATERIALIZED SRC_SOURCE_NAME SRC_TABLE_PREFIX SRC_SOURCE_TABLE_PREFIX_STAGE \
        INT_DESCRIPTORS FROM_CLAUSE_TEMPLATE SQL_REFERENCE_DIR VERSION_LOG \
        RELEASE_ASSETS RELEASE_TAG REFRESH \
        SRC_RELEASE_ASSETS INT_RELEASE_ASSETS PROGRAM_RELEASE_ASSETS COMMON_RELEASE_ASSETS STB_RELEASE_ASSETS \
        SRC_DD_DIR INT_DD_DIR PROGRAM_DD_DIR COMMON_DD_DIR STB_DD_DIR \
        SRC_STAGE_DIR INT_STAGE_DIR PROGRAM_STAGE_DIR COMMON_STAGE_DIR STB_STAGE_DIR \
        SRC_TABLE_PREFIX_STAGE INT_TABLE_PREFIX_STAGE PROGRAM_TABLE_PREFIX_STAGE \
        COMMON_TABLE_PREFIX_STAGE STB_TABLE_PREFIX_STAGE \
        STUDIES_VAR COMMON_STUDIES_VAR \
        ACCESS_MODELS_ROOT ACCESS_FROM_CLAUSE_TEMPLATE STB_FROM_CLAUSE_TEMPLATE
    do
        if value="$(printenv "$name")"; then stage_args+=("$name=$value"); fi
    done
'

_resolve_stage_env := '
    stage="${STAGE_INPUT:-}"
    study_id="${STUDY_ID:-}"

    case "$stage" in
        src)
            stage_dd_dir="${SRC_DD_DIR:-}"
            stage_release_assets="${SRC_RELEASE_ASSETS:-${RELEASE_ASSETS:-}}"
            stage_dir_override="${SRC_STAGE_DIR:-}"
            stage_table_prefix_override="${SRC_TABLE_PREFIX_STAGE:-}"
            ;;
        int)
            stage_dd_dir="${INT_DD_DIR:-}"
            stage_release_assets="${INT_RELEASE_ASSETS:-${RELEASE_ASSETS:-}}"
            if [[ -z "$stage_dd_dir" && -z "$stage_release_assets" ]]; then stage_dd_dir="${SRC_DD_DIR:-}"; fi
            stage_dir_override="${INT_STAGE_DIR:-}"
            stage_table_prefix_override="${INT_TABLE_PREFIX_STAGE:-}"
            ;;
        program)
            stage_dd_dir="${PROGRAM_DD_DIR:-}"
            stage_release_assets="${PROGRAM_RELEASE_ASSETS:-${RELEASE_ASSETS:-}}"
            stage_dir_override="${PROGRAM_STAGE_DIR:-}"
            stage_table_prefix_override="${PROGRAM_TABLE_PREFIX_STAGE:-}"
            ;;
        access|access_common)
            stage_dd_dir=""
            if [[ "$stage" == access ]]; then
                stage_release_assets="${PROGRAM_RELEASE_ASSETS:-${RELEASE_ASSETS:-}}"
            else
                stage_release_assets="${COMMON_RELEASE_ASSETS:-${RELEASE_ASSETS:-}}"
            fi
            access_name="${PROGRAM_ID:-}_${stage#access_}"
            if [[ "$stage" == access ]]; then access_name="${PROGRAM_ID:-}_access"; fi
            stage_dir_override="${ACCESS_MODELS_ROOT:-}/$access_name"
            stage_table_prefix_override="$access_name"
            ;;
        common)
            stage_dd_dir="${COMMON_DD_DIR:-}"
            stage_release_assets="${COMMON_RELEASE_ASSETS:-${RELEASE_ASSETS:-}}"
            stage_dir_override="${COMMON_STAGE_DIR:-}"
            stage_table_prefix_override="${COMMON_TABLE_PREFIX_STAGE:-}"
            ;;
        stb)
            stage_dd_dir="${STB_DD_DIR:-}"
            stage_release_assets="${STB_RELEASE_ASSETS:-${RELEASE_ASSETS:-}}"
            stage_dir_override="${STB_STAGE_DIR:-}"
            stage_table_prefix_override="${STB_TABLE_PREFIX_STAGE:-}"
            ;;
        *)
            echo "Unknown stage: $stage (expected: src|int|program|access|access_common|common|stb)" >&2
            exit 2
            ;;
    esac

    if [[ -z "$stage_dd_dir" && -z "$stage_release_assets" ]]; then
        echo "Set ${stage^^}_DD_DIR or ${stage^^}_RELEASE_ASSETS before running stage $stage." >&2
        exit 2
    fi

    if [[ -n "$stage_dd_dir" && -d "$stage_dd_dir/$stage/$study_id" ]]; then
        stage_dd_dir="$stage_dd_dir/$stage/$study_id"
    elif [[ -n "$stage_dd_dir" && -d "$stage_dd_dir/$stage" ]]; then
        stage_dd_dir="$stage_dd_dir/$stage"
    fi

    if [[ -n "$stage_dd_dir" && ! -e "$stage_dd_dir" ]]; then
        if [[ -n "$stage_release_assets" ]]; then
            stage_dd_dir=""
        else
            echo "Configured DD path does not exist for stage $stage: $stage_dd_dir" >&2
            exit 2
        fi
    fi

    if [[ -d "$stage_dd_dir" && -z "$stage_release_assets" ]]; then
        shopt -s nullglob nocaseglob
        dd_files=("$stage_dd_dir"/*_dd.csv "$stage_dd_dir"/*-dd.csv "$stage_dd_dir"/*_dictionary.csv "$stage_dd_dir"/*-dictionary.csv "$stage_dd_dir"/*_dd.xlsx "$stage_dd_dir"/*-dd.xlsx "$stage_dd_dir"/*_dictionary.xlsx "$stage_dd_dir"/*-dictionary.xlsx)
        if (( ${#dd_files[@]} == 0 )); then
            echo "No DD files found in $stage_dd_dir for stage $stage." >&2
            exit 2
        fi
    fi

    default_stage_dir="${MODELS_STAGE_ROOT:-}/$study_id/$stage"
    stage_dir="${stage_dir_override:-$default_stage_dir}"

    default_stage_table_prefix="${PROGRAM_ID:-}_${study_id}_${stage}"
    if [[ -n "$stage_table_prefix_override" ]]; then
        stage_table_prefix="$stage_table_prefix_override"
    else
        stage_table_prefix="$default_stage_table_prefix"
    fi

    stage_models_yml="$stage_dir/_models.yml"
    stage_models_docs="$stage_dir/_column_descriptions.md"
    stage_sources_yml="$stage_dir/_sources.yml"
    stage_sources_docs="$stage_dir/_column_descriptions.md"
    stage_sources_table_prefix="$stage_table_prefix"
    stage_int_descriptors=""
    stage_normalize_model_columns=""
    if [[ "$stage" == "int" ]]; then
        stage_int_descriptors="${INT_DESCRIPTORS:-}"
        stage_normalize_model_columns="true"
    fi
    # STB SQL aliases are lowercase, so its model YAML must match them.
    if [[ "$stage" == "stb" ]]; then stage_normalize_model_columns="true"; fi
    stage_sql_dir="$stage_dir"
    stage_src_sql_dir="$stage_dir"
    stage_program_ref_prefix=""
    stage_studies_var="${STUDIES_VAR:-${PROGRAM_ID:-}_studies}"
    if [[ "$stage" == common ]]; then stage_studies_var="${COMMON_STUDIES_VAR:-}"; fi
    if [[ "$stage" == program || "$stage" == common ]]; then stage_sql_recipe=_gen_stb_union_sql; else stage_sql_recipe=_gen_model_sql; fi

    # Derived names shared with the basic justfile; explicit values win.
    name_base="${PROGRAM_ID:-}_${study_id}"
    export SOURCE_SCHEMA="${SOURCE_SCHEMA:-${name_base}_raw}"
    src_prefix="${SRC_TABLE_PREFIX_STAGE:-${SRC_TABLE_PREFIX:-${name_base}_src}}"
    source_table_prefix="${SRC_SOURCE_TABLE_PREFIX_STAGE:-${SOURCE_SCHEMA:-}}"
    if [[ "$source_table_prefix" == none ]]; then source_table_prefix=""; fi
    if [[ "$src_prefix" == none ]]; then src_prefix=""; fi
    if [[ "$stage_table_prefix" == none ]]; then stage_table_prefix=""; fi
    stage_source_name="${SRC_SOURCE_NAME:-${name_base}_src}"
    q="$(printf "\047")"
    case "$stage" in
        src)
            stage_sources_table_prefix="$source_table_prefix"
            stage_table_prefix=""
            ;;
        int)
            if [[ -z "${FROM_CLAUSE_TEMPLATE:-}" ]]; then
                ref_name="{base_name}"
                if [[ -n "$src_prefix" ]]; then ref_name="${src_prefix}_{base_name}"; fi
                export FROM_CLAUSE_TEMPLATE="{{ ref(${q}${ref_name}${q}) }}"
            fi
            ;;
        access|access_common)
            program_prefix="${PROGRAM_TABLE_PREFIX_STAGE:-${PROGRAM_ID:-}_program}"
            if [[ -z "${ACCESS_FROM_CLAUSE_TEMPLATE:-}" ]]; then
                stage_program_ref_prefix="$program_prefix"
                unset FROM_CLAUSE_TEMPLATE
            else
                export FROM_CLAUSE_TEMPLATE="${ACCESS_FROM_CLAUSE_TEMPLATE:-}"
            fi
            ;;
        stb)
            # Blank generates FROM-less scaffolding so missing INT models do not break parsing.
            if [[ -n "${STB_FROM_CLAUSE_TEMPLATE:-}" ]]; then
                export FROM_CLAUSE_TEMPLATE="$STB_FROM_CLAUSE_TEMPLATE"
            else
                unset FROM_CLAUSE_TEMPLATE
            fi
            ;;
    esac
'

# Direct generator wrappers.
generate-models-yml:
    just -f common.just _gen_models

generate-sources-yml:
    just -f common.just _gen_sources

generate-model-sql:
    just -f common.just _gen_model_sql

generate-src-sql:
    just -f common.just _gen_src_sql

generate-stage-models-yml stage:
    #!/usr/bin/env bash
    set -euo pipefail
    STAGE_INPUT="{{stage}}"
    {{ _resolve_stage_env }}
    DD_DIR="$stage_dd_dir" \
    RELEASE_ASSETS="$stage_release_assets" \
    TABLE_PREFIX="$stage_table_prefix" \
    MODELS_YML="$stage_models_yml" \
    MODELS_DOCS="$stage_models_docs" \
    NORMALIZE_MODEL_COLUMNS="$stage_normalize_model_columns" \
    just -f common.just _gen_models

generate-stage-sources-yml stage:
    #!/usr/bin/env bash
    set -euo pipefail
    STAGE_INPUT="{{stage}}"
    {{ _resolve_stage_env }}
    DD_DIR="$stage_dd_dir" \
    RELEASE_ASSETS="$stage_release_assets" \
    TABLE_PREFIX="$stage_sources_table_prefix" \
    SOURCES_YML="$stage_sources_yml" \
    SOURCES_DOCS="$stage_sources_docs" \
    SOURCE_NAME="$stage_source_name" \
    just -f common.just _gen_sources

generate-stage-model-sql stage:
    #!/usr/bin/env bash
    set -euo pipefail
    STAGE_INPUT="{{stage}}"
    {{ _resolve_stage_env }}
    DD_DIR="$stage_dd_dir" \
    RELEASE_ASSETS="$stage_release_assets" \
    TABLE_PREFIX="$stage_table_prefix" \
    INT_DESCRIPTORS="$stage_int_descriptors" \
    PROGRAM_REF_PREFIX="$stage_program_ref_prefix" \
    SQL_DIR="$stage_sql_dir" \
    STUDIES_VAR="$stage_studies_var" \
    just -f common.just "$stage_sql_recipe"

generate-stage-src-sql stage:
    #!/usr/bin/env bash
    set -euo pipefail
    STAGE_INPUT="{{stage}}"
    {{ _resolve_stage_env }}
    DD_DIR="$stage_dd_dir" \
    RELEASE_ASSETS="$stage_release_assets" \
    TABLE_PREFIX="$source_table_prefix" \
    SRC_TABLE_PREFIX="$src_prefix" \
    SRC_SQL_DIR="$stage_src_sql_dir" \
    SRC_SOURCE_NAME="$stage_source_name" \
    just -f common.just _gen_src_sql

generate-stage stage:
    #!/usr/bin/env bash
    set -euo pipefail
    STAGE_INPUT="{{stage}}"
    {{ _resolve_stage_env }}

    if [[ "{{stage}}" == "src" ]]; then
        DD_DIR="$stage_dd_dir" \
        RELEASE_ASSETS="$stage_release_assets" \
        TABLE_PREFIX="$stage_sources_table_prefix" \
        SOURCES_YML="$stage_sources_yml" \
        SOURCES_DOCS="$stage_sources_docs" \
        SOURCE_NAME="$stage_source_name" \
        just -f common.just _gen_sources

        DD_DIR="$stage_dd_dir" \
        RELEASE_ASSETS="$stage_release_assets" \
        TABLE_PREFIX="$source_table_prefix" \
        SRC_TABLE_PREFIX="$src_prefix" \
        SRC_SQL_DIR="$stage_src_sql_dir" \
        SRC_SOURCE_NAME="$stage_source_name" \
        just -f common.just _gen_src_sql
    else
        DD_DIR="$stage_dd_dir" \
        RELEASE_ASSETS="$stage_release_assets" \
        TABLE_PREFIX="$stage_table_prefix" \
        MODELS_YML="$stage_models_yml" \
        MODELS_DOCS="$stage_models_docs" \
        NORMALIZE_MODEL_COLUMNS="$stage_normalize_model_columns" \
        just -f common.just _gen_models

        DD_DIR="$stage_dd_dir" \
        RELEASE_ASSETS="$stage_release_assets" \
        TABLE_PREFIX="$stage_table_prefix" \
        INT_DESCRIPTORS="$stage_int_descriptors" \
        PROGRAM_REF_PREFIX="$stage_program_ref_prefix" \
        SQL_DIR="$stage_sql_dir" \
        STUDIES_VAR="$stage_studies_var" \
        just -f common.just "$stage_sql_recipe"
    fi

generate-all-stages:
    #!/usr/bin/env bash
    set -euo pipefail
    {{ _stage_args }}
    for stage in $PIPELINE_STAGES; do
        just -f "{{justfile()}}" "${stage_args[@]}" generate-stage "$stage"
    done

generate-pipeline-sql:
    #!/usr/bin/env bash
    set -euo pipefail
    {{ _stage_args }}
    for stage in $PIPELINE_STAGES; do
        if [[ "$stage" == src ]]; then
            recipe=generate-stage-src-sql
        else
            recipe=generate-stage-model-sql
        fi
        just -f "{{justfile()}}" "${stage_args[@]}" "$recipe" "$stage"
    done

# Download the selected program and/or common CDM bundle without generating models.
refresh-releases bundle="all":
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{bundle}}" in
        all) bundles="${REFRESH_BUNDLES:-program common}" ;;
        program|common) bundles="{{bundle}}" ;;
        *) echo "Unknown bundle: {{bundle}} (expected: all|program|common)" >&2; exit 2 ;;
    esac
    for bundle in $bundles; do
        if [[ "$bundle" == program ]]; then
            repo="${PROGRAM_RELEASE_REPO:-}"
            out_dir="${PROGRAM_REFRESH_DIR:-}"
        else
            repo="${COMMON_RELEASE_REPO:-}"
            out_dir="${COMMON_REFRESH_DIR:-}"
        fi
        if [[ -z "$out_dir" || -z "$DBT_INTERNAL_PATH" ]]; then
            echo "Set a refresh output directory and DBT_INTERNAL_PATH before refreshing $bundle." >&2
            exit 2
        fi
        RELEASE_REPO="$repo" RELEASE_INTERNAL_PATH="$DD_INTERNAL_PATH" RELEASE_OUTPUT_PATH="$out_dir" \
            just -f common.just _extract_release_file
        RELEASE_REPO="$repo" RELEASE_INTERNAL_PATH="$DBT_INTERNAL_PATH" RELEASE_OUTPUT_PATH="$out_dir/dbt" \
            just -f common.just _extract_release_file
    done

extract-release-file:
    just -f common.just _extract_release_file

clean-dir stage="":
    #!/usr/bin/env bash
    set -euo pipefail
    output_dir="${SQL_DIR:-}"
    if [[ -n "{{stage}}" ]]; then
        STAGE_INPUT="{{stage}}"
        {{ _resolve_stage_env }}
        output_dir="$stage_sql_dir"
    fi
    if [[ -z "$output_dir" ]]; then
        echo "Pass a stage to clean-dir or set SQL_DIR." >&2
        exit 2
    fi
    if [[ -d "$output_dir" ]]; then
        find "$output_dir" -type f -name '*_generated.sql' -delete
    fi
