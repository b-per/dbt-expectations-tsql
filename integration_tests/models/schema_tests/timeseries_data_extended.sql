with dates as (

    select 
        * 
    from 
        {{ ref('timeseries_data_base_dates') }}

),
generate_series as (
    
    select
        generated_number AS rnd
    from 
        {{ ref('timeseries_data_generate_series') }}
),
add_row_values as (

    select
        d.date_day,
        cast(floor(100 * generate_series.rnd) as {{ dbt_utils.type_int() }}) as row_value
    from
        dates d
        cross join
        generate_series

),
add_logs as (

    select
        *,
        {{ dbt_expectations.log_natural('nullif(row_value, 0)') }} as row_value_log
    from
        add_row_values
)
select
    *
from
    add_logs
