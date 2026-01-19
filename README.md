# dbt (Data Build Tool) Learning Project

A comprehensive hands-on project for learning dbt (Data Build Tool) with MariaDB. This repository demonstrates dbt concepts through four real-world data domains: NYC taxi trips, cryptocurrency prices, excavator equipment maintenance, and mobile advertising data.

## Table of Contents

1. [Project Overview](#project-overview)
2. [What is dbt?](#what-is-dbt)
3. [Project Structure](#project-structure)
4. [Setup and Installation](#setup-and-installation)
5. [Data Domains](#data-domains)
6. [Core dbt Concepts](#core-dbt-concepts)
7. [Models](#models)
8. [Seeds](#seeds)
9. [Tests](#tests)
10. [Documentation](#documentation)
11. [Materialization Strategies](#materialization-strategies)
12. [Common dbt Commands](#common-dbt-commands)
13. [SQL Reference Files](#sql-reference-files)

---

## Project Overview

This project serves as a practical learning environment for understanding dbt fundamentals. It includes:

- **20 models** across 4 data domains
- **30 tests** including built-in and custom generic tests
- **5 seed files** with sample data
- **Comprehensive documentation** using Jinja doc blocks
- **SQL reference files** showing dbt-to-raw-SQL translations

### Technology Stack

| Component | Version |
|-----------|---------|
| dbt-core | 1.7.19 |
| dbt-mysql (MariaDB adapter) | 1.7.0 |
| MariaDB | 12.1.2 |
| Python | 3.12.2 |

---

## What is dbt?

dbt (Data Build Tool) is a transformation tool that enables data analysts and engineers to transform data in their warehouse using SQL. Key concepts include:

### The ref() Function

The `ref()` function is the foundation of dbt. It creates dependencies between models and allows dbt to build models in the correct order.

```sql
-- In dbt (models/taxi_trips/over_nine_miles.sql)
SELECT * FROM {{ ref('taxi_trips') }} WHERE distance > 9

-- What dbt compiles to:
SELECT * FROM taxi_trips WHERE distance > 9
```

### Why Use dbt?

1. **Dependency Management**: dbt automatically determines the order to run models based on `ref()` calls
2. **Documentation**: Built-in documentation generation from YAML and markdown files
3. **Testing**: Data quality tests defined in YAML schema files
4. **Version Control**: SQL-based transformations that can be tracked in git
5. **Modularity**: Reusable models that other models can reference

---

## Project Structure

```
DTB-FOR-SQL/
├── dbt_sql/                          # Main dbt project directory
│   ├── dbt_project.yml               # Project configuration
│   ├── models/                       # SQL transformation models
│   │   ├── taxi_trips/               # NYC taxi trip analytics
│   │   │   ├── taxi_trips.sql
│   │   │   ├── over_nine_miles.sql
│   │   │   ├── cross_borough.sql
│   │   │   ├── credit_card_count.sql
│   │   │   ├── avg_num_dropoff_manhattan.sql
│   │   │   └── docs/
│   │   │       ├── schema.yml
│   │   │       └── doc_blocks.md
│   │   ├── crypto_data/              # Cryptocurrency price analytics
│   │   │   ├── crypto_data.sql
│   │   │   ├── btc.sql
│   │   │   ├── eth.sql
│   │   │   ├── link.sql
│   │   │   ├── oxt.sql
│   │   │   ├── xlm.sql
│   │   │   ├── xrp.sql
│   │   │   ├── btc_closing_above_3k.sql
│   │   │   └── docs/
│   │   │       ├── schema.yml
│   │   │       └── doc_blocks.md
│   │   ├── excavators/               # Equipment maintenance tracking
│   │   │   ├── excavators.sql
│   │   │   ├── jobs.sql
│   │   │   ├── maintenance.sql
│   │   │   ├── maintenance_cte.sql
│   │   │   └── docs/
│   │   │       ├── schema.yml
│   │   │       └── doc_blocks.md
│   │   ├── adid_data/                # Mobile advertising analytics
│   │   │   ├── adid_data.sql
│   │   │   └── docs/
│   │   │       ├── schema.yml
│   │   │       └── doc_blocks.md
│   │   └── example/                  # Default dbt example models
│   │       ├── my_first_dbt_model.sql
│   │       ├── my_second_dbt_model.sql
│   │       └── schema.yml
│   ├── seeds/                        # CSV source data
│   │   ├── taxi_trips/
│   │   │   └── raw_taxi_trips.csv
│   │   ├── crypto_data/
│   │   │   └── raw_crypto_data.csv
│   │   ├── excavators/
│   │   │   ├── raw_excavators.csv
│   │   │   └── raw_jobs.csv
│   │   └── adid_data/
│   │       └── raw_adid_data.csv
│   ├── tests/                        # Custom generic tests
│   │   └── generic/
│   │       ├── custom_test.sql
│   │       └── ensure_cohort_size_max_100.sql
│   └── target/                       # Compiled SQL and artifacts
├── dbt_equivalent_sql/               # SQL reference documentation
│   ├── taxi_trips_dbt_sql_commands.sql
│   ├── crypto_data_dbt_sql_commands.sql
│   ├── excavators_dbt_sql_commands.sql
│   └── adid_data_dbt_sql_commands.sql
├── venv/                             # Python virtual environment
└── requirements.txt                  # Python dependencies
```

---

## Setup and Installation

### Prerequisites

- Python 3.10 or higher
- MariaDB or MySQL database server
- Git

### Installation Steps

1. Clone the repository:
```bash
git clone <repository-url>
cd DTB-FOR-SQL
```

2. Create and activate a virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate  # On macOS/Linux
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Configure the database connection in `~/.dbt/profiles.yml`:
```yaml
dbt_sql:
  outputs:
    dev:
      type: mariadb
      threads: 1
      host: localhost
      port: 3306
      user: your_username
      password: your_password
      database: dbt_sql
      schema: dbt_sql
  target: dev
```

5. Verify the connection:
```bash
cd dbt_sql
dbt debug
```

6. Load seed data and run models:
```bash
dbt seed
dbt run
dbt test
```

---

## Data Domains

### 1. Taxi Trips (NYC Yellow Cab Data)

Sample dataset of 1,999 NYC taxi trip records including pickup/dropoff locations, fares, tips, and payment methods.

**Models:**
- `taxi_trips`: Base model with all trip data
- `over_nine_miles`: Trips exceeding 9 miles (airport trips, long distance)
- `cross_borough`: Trips crossing borough boundaries
- `credit_card_count`: Count of credit card payments
- `avg_num_dropoff_manhattan`: Average passengers for Manhattan dropoffs

### 2. Crypto Data (Cryptocurrency Prices)

Historical price data for 6 cryptocurrencies: BTC, ETH, LINK, OXT, XLM, XRP (5,318 records).

**Models:**
- `crypto_data`: Base model with incremental materialization
- `btc`, `eth`, `link`, `oxt`, `xlm`, `xrp`: Currency-specific filtered views
- `btc_closing_above_3k`: Bitcoin days closing above $3,000

### 3. Excavators (Equipment Maintenance)

Equipment maintenance tracking system with 100 excavators and 100 jobs.

**Models:**
- `excavators`: Equipment with maintenance indicators (oil, air filter, coolant, hydraulics)
- `jobs`: Job assignments with location and manager
- `maintenance`: Identifies failing equipment per job (UNION approach)
- `maintenance_cte`: Same logic refactored with CTEs for cleaner code

### 4. ADID Data (Mobile Advertising)

Mobile advertising data with device IDs, locations, and cohort assignments.

**Models:**
- `adid_data`: Base model with advertising IDs, coordinates, cities, dates, and cohorts

---

## Core dbt Concepts

### The ref() Function

The `ref()` function creates model dependencies and enables dbt to:
1. Build models in the correct order
2. Generate a DAG (Directed Acyclic Graph) of dependencies
3. Allow environment-specific schema references

```sql
-- models/taxi_trips/over_nine_miles.sql
SELECT * 
FROM {{ ref('taxi_trips') }}  -- References the taxi_trips model
WHERE distance > 9
```

### The config() Block

The `config()` block sets model-specific configurations:

```sql
{{ config(materialized='view') }}

SELECT * FROM {{ ref('raw_taxi_trips') }}
```

### Jinja Templating

dbt uses Jinja templating for dynamic SQL generation:

```sql
-- Conditional logic with is_incremental()
{{ config(materialized='incremental') }}

SELECT * FROM {{ ref('raw_crypto_data') }}

{% if is_incremental() %}
WHERE detail_date > (SELECT MAX(detail_date) FROM {{ this }})
{% endif %}
```

---

## Models

### Model Types by Function

**Base Models**: Direct selections from seed data
```sql
-- models/taxi_trips/taxi_trips.sql
SELECT * FROM {{ ref('raw_taxi_trips') }}
```

**Filtered Models**: Apply WHERE clauses to base models
```sql
-- models/taxi_trips/over_nine_miles.sql
SELECT * FROM {{ ref('taxi_trips') }} WHERE distance > 9
```

**Aggregation Models**: Perform calculations and groupings
```sql
-- models/taxi_trips/credit_card_count.sql
SELECT payment, COUNT(payment) AS credit_card_count
FROM {{ ref('taxi_trips') }}
WHERE payment = 'Credit card'
GROUP BY payment
```

**CTE Models**: Use Common Table Expressions for complex logic
```sql
-- models/excavators/maintenance_cte.sql
WITH failing_excavators AS (
    SELECT excavator_id
    FROM {{ ref('excavators') }}
    WHERE oil_level != 'P'
       OR air_filter != 'P'
       OR coolant_level != 'P'
       OR hydraulic_valves != 'P'
)
SELECT job_id, excavator_id
FROM {{ ref('jobs') }}
WHERE excavator_id IN (SELECT excavator_id FROM failing_excavators)
AND job_id IN (398, 417, 401, 332, 329, 340, 366, 373, 376, 423)
```

---

## Seeds

Seeds are CSV files that dbt loads into your database as tables. They are ideal for:
- Static reference data
- Lookup tables
- Sample data for development

### Loading Seeds

```bash
dbt seed                    # Load all seeds
dbt seed --select taxi_trips  # Load specific seed
```

### Seed Organization

Seeds follow the same domain-based folder structure as models:

```
seeds/
├── taxi_trips/
│   └── raw_taxi_trips.csv      # 1,999 rows
├── crypto_data/
│   └── raw_crypto_data.csv     # 5,318 rows
├── excavators/
│   ├── raw_excavators.csv      # 100 rows
│   └── raw_jobs.csv            # 100 rows
└── adid_data/
    └── raw_adid_data.csv       # Advertising data
```

### Important Note

Running `dbt seed` performs a full refresh by default. It drops and recreates the table each time, so there is no risk of duplicate data.

---

## Tests

dbt provides two types of tests: built-in (generic) tests and custom tests.

### Built-in Tests

Defined in `schema.yml` files:

```yaml
models:
  - name: taxi_trips
    columns:
      - name: pickup
        tests:
          - not_null
      - name: fare
        tests:
          - not_null
      - name: payment
        tests:
          - accepted_values:
              values: ['Credit card', 'Cash']
```

**Available built-in tests:**
- `not_null`: Ensures column has no NULL values
- `unique`: Ensures column has no duplicate values
- `accepted_values`: Ensures column only contains specified values
- `relationships`: Ensures referential integrity between tables

### Custom Generic Tests

Custom tests are Jinja macros in `tests/generic/`:

```sql
-- tests/generic/ensure_cohort_size_max_100.sql
{% test ensure_cohort_size_max_100(model, column_name) %}

WITH cohort_count_cte AS (
    SELECT cohort, COUNT(*) AS cohort_count
    FROM {{ model }}
    GROUP BY {{ column_name }}
)

SELECT cohort, cohort_count
FROM cohort_count_cte
WHERE cohort_count > 100

{% endtest %}
```

**How custom tests work:**
- Tests return rows that FAIL the condition
- If the query returns 0 rows, the test PASSES
- If the query returns any rows, the test FAILS

### Running Tests

```bash
dbt test                          # Run all tests
dbt test --select taxi_trips      # Test specific model
dbt test --select test_type:generic  # Run only generic tests
```

---

## Documentation

### Jinja Doc Blocks

Documentation is written using `{% docs %}` blocks in markdown files:

```markdown
<!-- models/taxi_trips/docs/doc_blocks.md -->
{% docs pickup %}
The timestamp when the passenger(s) were picked up by the taxi. 
This represents the start time of the trip.
{% enddocs %}

{% docs taxi_trips_model %}
# Taxi Trips - Base Model

This is the foundational model containing all taxi trip data.
It serves as the source for all downstream analytical models.
{% enddocs %}
```

### Schema YAML with Doc References

```yaml
# models/taxi_trips/docs/schema.yml
models:
  - name: taxi_trips
    description: '{{ doc("taxi_trips_model") }}'
    columns:
      - name: pickup
        description: '{{ doc("pickup") }}'
      - name: dropoff
        description: '{{ doc("dropoff") }}'
```

### Generating Documentation

```bash
dbt docs generate    # Create documentation JSON
dbt docs serve       # Start local documentation server
```

The documentation site provides:
- Model descriptions and column definitions
- Dependency lineage graphs
- Test coverage information
- Source code viewing

---

## Materialization Strategies

dbt supports different materialization strategies that determine how models are stored in the database.

### View (Default)

Creates a database view. The query runs each time the view is accessed.

```sql
{{ config(materialized='view') }}

SELECT * FROM {{ ref('raw_taxi_trips') }}
```

**Pros:** No storage overhead, always current data
**Cons:** Slower queries on large datasets
**Use for:** Small data, simple transformations, development

### Table

Creates a physical table. Data is stored on disk.

```sql
{{ config(materialized='table') }}

SELECT * FROM {{ ref('btc') }}
WHERE closing_price > 3000
```

**Pros:** Fast query performance, pre-computed results
**Cons:** Storage overhead, stale until rebuilt
**Use for:** Large datasets, complex transformations, dashboards

### Incremental

Only processes new or updated records on subsequent runs.

```sql
{{ config(materialized='incremental') }}

SELECT * FROM {{ ref('raw_crypto_data') }}

{% if is_incremental() %}
WHERE detail_date > (SELECT MAX(detail_date) FROM {{ this }})
{% endif %}
```

**Pros:** Efficient for time-series data, fast rebuilds
**Cons:** More complex logic, requires unique key strategy
**Use for:** Large append-only datasets, event data

### Comparison

| Materialization | Storage | Query Speed | Freshness | Build Time |
|----------------|---------|-------------|-----------|------------|
| View | None | Slow | Always current | Instant |
| Table | Full | Fast | Stale until rebuild | Slow |
| Incremental | Full | Fast | Stale until rebuild | Fast (after initial) |

---

## Common dbt Commands

### Essential Commands

| Command | Description |
|---------|-------------|
| `dbt seed` | Load CSV files into database tables |
| `dbt run` | Build all models |
| `dbt test` | Run data quality tests |
| `dbt build` | Run seed, run, and test in order |
| `dbt compile` | Compile Jinja to SQL without executing |
| `dbt docs generate` | Generate documentation files |
| `dbt docs serve` | Start documentation web server |
| `dbt debug` | Test database connection |
| `dbt clean` | Delete target/ and other artifacts |

### Selection Syntax

```bash
dbt run --select taxi_trips          # Run single model
dbt run --select taxi_trips+         # Run model and all downstream
dbt run --select +taxi_trips         # Run model and all upstream
dbt run --select crypto_data.*       # Run all models in folder
dbt run --select tag:daily           # Run models with specific tag
dbt test --select taxi_trips         # Test specific model
```

### Full Refresh

Force a complete rebuild of incremental models:

```bash
dbt run --full-refresh
```

---

## SQL Reference Files

The `dbt_equivalent_sql/` directory contains SQL files that demonstrate how dbt Jinja syntax translates to raw SQL. These are educational resources showing:

1. How `{{ ref() }}` becomes table names
2. How `{{ config() }}` affects CREATE statements
3. How tests translate to SQL queries
4. Model dependency chains

Example from `taxi_trips_dbt_sql_commands.sql`:

```sql
-- In dbt:
-- SELECT * FROM {{ ref('taxi_trips') }} WHERE distance > 9

-- Which is the same as:
SELECT * FROM taxi_trips WHERE distance > 9;
```

These files are not executed by dbt but serve as learning references.

---

## Model Dependency Chains

### Taxi Trips

```
raw_taxi_trips (seed)
└── taxi_trips (view)
    ├── over_nine_miles (view)
    ├── cross_borough (view)
    ├── credit_card_count (view)
    └── avg_num_dropoff_manhattan (view)
```

### Crypto Data

```
raw_crypto_data (seed)
└── crypto_data (incremental)
    ├── btc (view) → btc_closing_above_3k (table)
    ├── eth (view)
    ├── link (view)
    ├── oxt (view)
    ├── xlm (view)
    └── xrp (view)
```

### Excavators

```
raw_excavators (seed) → excavators (view) ─┐
                                           ├── maintenance (view)
raw_jobs (seed) → jobs (view) ─────────────┤
                                           └── maintenance_cte (view)
```

### ADID Data

```
raw_adid_data (seed)
└── adid_data (view)
```

---

## Best Practices Demonstrated

1. **Domain-Based Organization**: Models and seeds organized by business domain
2. **Documentation in docs/ Folders**: Separation of SQL and documentation
3. **Jinja Doc Blocks**: Reusable documentation across multiple models
4. **Custom Tests**: Business-specific data quality rules
5. **CTE Refactoring**: Cleaner code through Common Table Expressions
6. **Incremental Models**: Efficient processing of time-series data
7. **SQL Reference Files**: Educational resources for understanding dbt internals

---

## Additional Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [dbt Learn](https://courses.getdbt.com/)
- [dbt Community Slack](https://community.getdbt.com/)
- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)

---

## License

This project is for educational purposes as part of coursework.
