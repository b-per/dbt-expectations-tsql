{% macro sqlserver__test_expect_column_stdev_to_be_between(model, column_name,
                                                    min_value,
                                                    max_value,
                                                    row_condition
                                                    ) %}

{% set expression %}
stdev({{ column_name }})
{% endset %}
{{ dbt_expectations.expression_between(model,
                                        expression=expression,
                                        min_value=min_value,
                                        max_value=max_value,
                                        row_condition=row_condition
                                        ) }}
{% endmacro %}
