-- Active: 1768535148169@@127.0.0.1@3306@dbt_sql
-- ============================================================================
-- UNDERSTANDING DBT MODELS - ADID DATA (MOBILE ADVERTISING)
-- ============================================================================

-- ============================================================================
-- 1. adid_data.sql (Base Model)
-- ============================================================================
-- The foundational model containing mobile advertising ID data.
-- Tracks device locations and cohort assignments for ad campaign analysis.
-- In dbt:
-- {{ config(materialized='view') }}
-- WITH source AS (SELECT * FROM {{ ref('raw_adid_data') }})
-- SELECT adid, latitude, longitude, city, eventdate, cohort FROM source

-- What dbt creates:
CREATE OR REPLACE VIEW adid_data AS
WITH source AS (
    SELECT * FROM raw_adid_data
)
SELECT adid, latitude, longitude, city, eventdate, cohort 
FROM source;

-- Which is the same as:
SELECT * FROM adid_data;

-- ============================================================================
-- CUSTOM TEST: ensure_cohort_size_max_100
-- ============================================================================
-- Custom generic test to validate that no cohort has more than 100 ADIDs.
-- In dbt (tests/generic/ensure_cohort_size_max_100.sql):
-- {% test ensure_cohort_size_max_100(model, column_name) %}
-- WITH cohort_count_cte AS (
--     SELECT cohort, COUNT(*) AS cohort_count
--     FROM {{ model }}
--     GROUP BY {{ column_name }}
-- )
-- SELECT cohort, cohort_count
-- FROM cohort_count_cte
-- WHERE cohort_count > 100
-- {% endtest %}

-- Which translates to raw SQL:
WITH cohort_count_cte AS (
    SELECT cohort, COUNT(*) AS cohort_count
    FROM adid_data
    GROUP BY cohort
)
SELECT cohort, cohort_count
FROM cohort_count_cte
WHERE cohort_count > 100;

-- If this query returns ANY rows, the test FAILS
-- If this query returns 0 rows, the test PASSES

-- ============================================================================
-- BUILT-IN TESTS APPLIED
-- ============================================================================
-- Tests defined in schema.yml for adid_data model:

-- 1. unique (on adid column):
SELECT adid
FROM adid_data
GROUP BY adid
HAVING COUNT(*) > 1;
-- Returns duplicate ADIDs (test fails if any rows returned)

-- 2. not_null (on all columns):
SELECT * FROM adid_data WHERE adid IS NULL;
SELECT * FROM adid_data WHERE latitude IS NULL;
SELECT * FROM adid_data WHERE longitude IS NULL;
SELECT * FROM adid_data WHERE city IS NULL;
SELECT * FROM adid_data WHERE eventdate IS NULL;
SELECT * FROM adid_data WHERE cohort IS NULL;
-- Each returns rows where column is null (test fails if any rows returned)

-- 3. accepted_values (on cohort column):
SELECT cohort
FROM adid_data
WHERE cohort NOT IN ('one', 'two', 'three', 'four', 'five', 'six');
-- Returns invalid cohort values (test fails if any rows returned)

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- {{ ref('adid_data') }} in dbt → adid_data in SQL
-- {{ ref('raw_adid_data') }} in dbt → raw_adid_data in SQL
--
-- Model Dependency Chain:
-- raw_adid_data (seed) → adid_data (view)
--
-- Columns in adid_data:
-- - adid: Unique advertising ID for mobile devices
-- - latitude: Geographic latitude coordinate
-- - longitude: Geographic longitude coordinate
-- - city: City where event was recorded
-- - eventdate: Date of the advertising event
-- - cohort: User cohort (one, two, three, four, five, six)
--
-- Tests Applied:
-- - unique: Ensures no duplicate ADIDs
-- - not_null: Ensures all fields have values
-- - accepted_values: Ensures cohort is valid
-- - ensure_cohort_size_max_100: Custom test for cohort size limits
-- ============================================================================
