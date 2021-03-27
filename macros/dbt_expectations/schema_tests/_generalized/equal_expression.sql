{%- macro sqlserver__get_select(model, expression, row_condition, group_by) %}
    select
        {% for g in group_by -%}
            {{ g }} as col_{{ loop.index }},
        {% endfor -%}
        {{ expression }} as expression
    from
        {{ model }}
    {%- if row_condition %}
    where
        {{ row_condition }}
    {% endif %}
    {%- if group_by|length > 1 or group_by[0] != "'col'" %}
    group by
        {% for g in group_by -%}
            {{ g }}{% if not loop.last %},{% endif %}
        {% endfor %}
    {% endif %}
{% endmacro -%}

{%- macro sqlserver__test_equal_expression(model, expression,
                                compare_model,
                                compare_expression,
                                group_by,
                                compare_group_by,
                                row_condition,
                                compare_row_condition,
                                tolerance,
                                tolerance_percent) -%}

    {%- set compare_model = model if not compare_model else compare_model -%}
    {%- set compare_expression = expression if not compare_expression else compare_expression -%}
    {%- set compare_row_condition = row_condition if not compare_row_condition else compare_row_condition -%}
    {%- set compare_group_by = group_by if not compare_group_by else compare_group_by -%}

    {%- set n_cols = group_by|length %}
    with a as (
        {{ dbt_expectations.get_select(model, expression, row_condition, group_by) }}
    ),
    b as (
        {{ dbt_expectations.get_select(compare_model, compare_expression, compare_row_condition, compare_group_by) }}
    ),
    final as (

        select
            {% for i in range(1, n_cols + 1) -%}
            coalesce(a.col_{{ i }}, b.col_{{ i }}) as col_{{ i }},
            {% endfor %}
            a.expression,
            b.expression as compare_expression,
            abs(coalesce(a.expression, 0) - coalesce(b.expression, 0)) as expression_difference,
            abs(coalesce(a.expression, 0) - coalesce(b.expression, 0))/
                nullif(a.expression, 0) as expression_difference_percent
        from
            a
            full outer join
            b on
            {% for i in range(1, n_cols + 1) -%}
                a.col_{{ i }} = b.col_{{ i }} {% if not loop.last %}and{% endif %}
            {% endfor -%}
    )
    -- DEBUG:
    -- select * from final
    select count(*) from final
    where
        expression_difference > {{ tolerance }}
        {% if tolerance_percent %}
        and expression_difference_percent > {{ tolerance_percent }}
        {% endif %}
{%- endmacro -%}
