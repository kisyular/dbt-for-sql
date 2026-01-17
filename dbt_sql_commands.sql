-- Active: 1768535148169@@127.0.0.1@3306@dbt_sql
-- ============================================================================
-- UNDERSTANDING DBT MODELS - SIMPLE EXPLANATION
-- ============================================================================

-- ============================================================================
-- 1. taxi_trips.sql (Base Model)
-- ============================================================================
-- The foundational model that all other models reference.
-- In dbt: SELECT * FROM {{ ref('raw_taxi_trips') }}
-- Creates a view named 'taxi_trips' in the dbt_sql schema.

-- What dbt creates:
CREATE OR REPLACE VIEW taxi_trips AS
SELECT * FROM raw_taxi_trips;

-- Which is the same as:
SELECT * FROM taxi_trips;

-- ============================================================================
-- 2. over_nine_miles.sql (Filtered Model)
-- ============================================================================
-- Filters taxi_trips to show only trips with distance > 9 miles.
-- Useful for analyzing long-distance trips.
-- In dbt: SELECT * FROM {{ ref('taxi_trips') }} WHERE distance > 9

-- Which is the same as:
SELECT * FROM taxi_trips WHERE distance > 9;

-- ============================================================================
-- 3. cross_borough.sql (Filtered Model)
-- ============================================================================
-- Shows trips that cross borough boundaries.
-- In dbt:
-- SELECT * FROM {{ ref('taxi_trips') }} WHERE pickup_borough <> dropoff_borough

-- Which is the same as:
SELECT * FROM taxi_trips WHERE pickup_borough <> dropoff_borough;

-- ============================================================================
-- 4. credit_card_count.sql (Aggregation Model)
-- ============================================================================
-- Counts credit card payments.
-- In dbt:
-- SELECT payment, COUNT(payment) AS credit_card_count
-- FROM {{ ref('taxi_trips') }}
-- WHERE payment = 'Credit card'

-- Which is the same as:
SELECT 
    payment, 
    COUNT(payment) AS credit_card_count
FROM taxi_trips
WHERE payment = 'Credit card';

-- ============================================================================
-- 5. avg_num_dropoff_manhattan.sql (Aggregation Model)
-- ============================================================================
-- Average passengers for Manhattan dropoffs.
-- In dbt:
-- SELECT AVG(passengers) AS avg_num_passengers_manhattan
-- FROM {{ ref('taxi_trips') }}
-- WHERE dropoff_borough = 'Manhattan'

-- Which is the same as:
SELECT 
    AVG(passengers) AS avg_num_passengers_manhattan
FROM taxi_trips
WHERE dropoff_borough = 'Manhattan';

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- {{ ref('taxi_trips') }} in dbt → taxi_trips in SQL
-- {{ ref('raw_taxi_trips') }} in dbt → raw_taxi_trips in SQL
--
-- dbt just replaces {{ ref('model_name') }} with the actual table/view name!
-- ============================================================================