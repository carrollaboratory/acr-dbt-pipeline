{% macro extract_source_concepts(sources) %}
  {% if sources is not mapping or sources | length == 0 %}
    {{ exceptions.raise_compiler_error('extract_source_concepts: sources must be a non-empty dictionary of relations and column configurations.') }}
  {% endif %}
  {% for relation, fields in sources.items() %}
    {% if fields is string or fields is mapping or fields is not sequence or fields | length == 0 %}
      {{ exceptions.raise_compiler_error('extract_source_concepts: each relation needs a non-empty list of column configurations.') }}
    {% endif %}
    {% for field in fields %}
      {% if field is not mapping %}
        {{ exceptions.raise_compiler_error('extract_source_concepts: each column configuration must be a dictionary.') }}
      {% endif %}
      {% for key, value in field.items() %}
        {% if key not in ['text_column', 'concept_column', 'text_delimiter', 'concept_delimiter', 'concept_strip_chars'] %}
          {{ exceptions.raise_compiler_error('extract_source_concepts: unknown option ' ~ key) }}
        {% endif %}
        {% if value is not string or value | length == 0 %}
          {{ exceptions.raise_compiler_error('extract_source_concepts: ' ~ key ~ ' must be a non-empty string; omit unused options.') }}
        {% endif %}
      {% endfor %}
      {% if not field.get('text_column') and not field.get('concept_column') %}
        {{ exceptions.raise_compiler_error('extract_source_concepts: specify text_column, concept_column, or both.') }}
      {% endif %}
      {% for side in ['text', 'concept'] %}
        {% if field.get(side ~ '_delimiter') and not field.get(side ~ '_column') %}
          {{ exceptions.raise_compiler_error('extract_source_concepts: ' ~ side ~ '_delimiter requires ' ~ side ~ '_column.') }}
        {% endif %}
      {% endfor %}
    {% endfor %}
  {% endfor %}

with
  {% for relation, fields in sources.items() %}
    {% set table_index = loop.index %}
    {% for field in fields %}
      {% set field_id = table_index ~ '_' ~ loop.index %}
raw_{{ field_id }} as (
    select distinct
        {% if field.get('text_column') %}cast({{ adapter.quote(field['text_column']) }} as text){% else %}cast(null as text){% endif %} as raw_text,
        {% if field.get('concept_column') %}cast({{ adapter.quote(field['concept_column']) }} as text){% else %}cast(null as text){% endif %} as raw_concept
    from {{ relation }}
),
split_{{ field_id }} as (
    select
        raw_text,
        raw_concept,
        {% if field.get('text_delimiter') %}string_split(raw_text, '{{ field["text_delimiter"] | replace("'", "''") }}'){% else %}[raw_text]{% endif %} as text_tokens,
        {% if field.get('concept_delimiter') %}string_split(raw_concept, '{{ field["concept_delimiter"] | replace("'", "''") }}'){% else %}[raw_concept]{% endif %} as concept_tokens
    from raw_{{ field_id }}
),
paired_{{ field_id }} as (
    select
        raw_text,
        raw_concept,
        -- Use the longer list; missing partners stay NULL, without a Cartesian product.
        unnest(range(1, greatest(len(text_tokens), len(concept_tokens)) + 1)) as token_position,
        list_extract(text_tokens, token_position) as text_token,
        list_extract(concept_tokens, token_position) as concept_token
    from split_{{ field_id }}
),
    {% endfor %}
  {% endfor %}
normalized as (
  {% for relation, fields in sources.items() %}
    {% set table_index = loop.index %}
    {% set last_table = loop.last %}
    {% for field in fields %}
    select
        '{{ relation | string | replace("'", "''") }}'::text as table_ref,
        raw_text,
        raw_concept,
        nullif(trim(regexp_replace(text_token, '\s+', ' ', 'g')), '') as normalized_text,
        nullif(trim(regexp_replace(
          {% if field.get('concept_strip_chars') %}
            translate(concept_token, '{{ field["concept_strip_chars"] | replace("'", "''") }}', '')
          {% else %}
            concept_token
          {% endif %}
        , '\s+', ' ', 'g')), '') as normalized_concept,
        {% if field.get('text_column') %}'{{ field["text_column"] | replace("'", "''") }}'{% else %}null{% endif %}::text as text_column,
        {% if field.get('concept_column') %}'{{ field["concept_column"] | replace("'", "''") }}'{% else %}null{% endif %}::text as concept_column,
        token_position
    from paired_{{ table_index }}_{{ loop.index }}
      {% if not (last_table and loop.last) %}
    union all
      {% endif %}
    {% endfor %}
  {% endfor %}
)
select *
from normalized
where normalized_text is not null or normalized_concept is not null
{% endmacro %}
