{% macro generate_schema_name(schema_name, node) -%}
    {{ generate_schema_name_for_env(schema_name, node) }}
{%- endmacro %}
