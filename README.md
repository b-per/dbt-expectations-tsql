# This repo is now Archived. SQL Server support for [`dbt-expectations`](https://github.com/calogica/dbt-expectations) is part of the package [`tsql-utils`](https://github.com/dbt-msft/tsql-utils)

# dbt-expectations-tsql

This [dbt](https://github.com/fishtown-analytics/dbt) package contains macros for supporting [`dbt-expectations`](https://github.com/calogica/dbt-expectations) on SQL Server and Azure SQL DB.

## Installation

This package needs to be installed in your `packages.yml` file, in addition to [`tsql-utils`](https://github.com/dbt-msft/tsql-utils):
```
packages:
  - package: dbt-msft/tsql_utils
    version: 0.6.5
  - git: "https://github.com/b-per/dbt-expectations-tsql.git"
```

You also need to add the following to `dbt_project.yml` to mention to your dbt project that the `dbt-expectations` macros are supplemented by the ones from this package (supported time zones are available in `sys.time_zone_info`) and that the dbt-utils macros are complemented by the ones from `tsql-utils`

```
vars:
    'dbt_date:time_zone': 'AUS Eastern Standard Time'
    dbt_utils_dispatch_list: [tsql_utils]
    dbt_date_dispatch_list: [dbt_date_tsql]
    dbt_expectations_dispatch_list: [dbt_expectations_tsql]
```

## Supported/Unsupported functionalities 

This package passed most of the integration tests from `dbt-expectations 0.2.8` except the regexp ones, SQL Server not supporting typical regexp. 

The models in the integrations_tests had to be modified due to unsupported featues in TSQL.


## Utilisation

See the available macros in the original [`dbt-expectations`](https://github.com/calogica/dbt-expectations) repo 
