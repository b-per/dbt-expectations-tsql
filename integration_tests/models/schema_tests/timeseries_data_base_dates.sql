{# Needs to be in its separate model as it contains a WITH and nested WITH are not allowed on SQL Server #}

{{ dbt_date.get_base_dates(n_dateparts=12, datepart='month') }}