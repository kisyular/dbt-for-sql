-- Active: 1768535148169@@127.0.0.1@3306@dbt_sql
-- ============================================================================
-- UNDERSTANDING DBT MODELS - EXCAVATORS EQUIPMENT MAINTENANCE
-- ============================================================================

-- ============================================================================
-- 1. excavators.sql (Base Model)
-- ============================================================================
-- The foundational model containing all excavator equipment data.
-- Tracks maintenance status indicators for each excavator.
-- In dbt:
-- {{ config(materialized='view') }}
-- WITH source AS (SELECT * FROM {{ ref('raw_excavators') }})
-- SELECT excavator_id, oil_level, air_filter, coolant_level, hydraulic_valves FROM source

-- What dbt creates:
CREATE OR REPLACE VIEW excavators AS
WITH source AS (
    SELECT * FROM raw_excavators
)
SELECT excavator_id, oil_level, air_filter, coolant_level, hydraulic_valves 
FROM source;

-- Which is the same as:
SELECT * FROM excavators;

-- ============================================================================
-- 2. jobs.sql (Base Model)
-- ============================================================================
-- Contains all job assignments where excavators are deployed.
-- In dbt:
-- {{ config(materialized='view') }}
-- WITH source AS (SELECT * FROM {{ ref('raw_jobs') }})
-- SELECT job_id, excavator_id, city, manager FROM source

-- What dbt creates:
CREATE OR REPLACE VIEW jobs AS
WITH source AS (
    SELECT * FROM raw_jobs
)
SELECT job_id, excavator_id, city, manager 
FROM source;

-- Which is the same as:
SELECT * FROM jobs;

-- ============================================================================
-- 3. maintenance.sql (Filtered Model - UNION Approach)
-- ============================================================================
-- Identifies excavators that are NOT ready for specific jobs.
-- An excavator fails if any maintenance indicator != 'P' (Pass).
-- Uses multiple UNION statements for each job_id.
-- In dbt:
-- SELECT job_id, excavator_id FROM {{ ref('jobs') }}
-- WHERE excavator_id IN (SELECT excavator_id FROM {{ ref('excavators') }}
--   WHERE oil_level != 'P' OR air_filter != 'P' OR coolant_level != 'P' OR hydraulic_valves != 'P')
-- AND job_id = 398
-- UNION
-- ... (repeated for each job_id)

-- Which is the same as (showing first 3 UNIONs for brevity):
SELECT job_id, excavator_id
FROM jobs
WHERE excavator_id IN (
    SELECT excavator_id FROM excavators
    WHERE oil_level != 'P' OR air_filter != 'P' 
       OR coolant_level != 'P' OR hydraulic_valves != 'P'
)
AND job_id = 398

UNION

SELECT job_id, excavator_id
FROM jobs
WHERE excavator_id IN (
    SELECT excavator_id FROM excavators
    WHERE oil_level != 'P' OR air_filter != 'P' 
       OR coolant_level != 'P' OR hydraulic_valves != 'P'
)
AND job_id = 417

UNION

SELECT job_id, excavator_id
FROM jobs
WHERE excavator_id IN (
    SELECT excavator_id FROM excavators
    WHERE oil_level != 'P' OR air_filter != 'P' 
       OR coolant_level != 'P' OR hydraulic_valves != 'P'
)
AND job_id = 401;

-- Full list of job_ids: 398, 417, 401, 332, 329, 340, 366, 373, 376, 423

-- ============================================================================
-- 4. maintenance_cte.sql (Filtered Model - CTE Approach)
-- ============================================================================
-- Same logic as maintenance.sql but refactored using CTEs for cleaner code.
-- In dbt:
-- {{ config(materialized='view') }}
-- WITH failing_excavators AS (
--     SELECT excavator_id FROM {{ ref('excavators') }}
--     WHERE oil_level != 'P' OR air_filter != 'P' 
--        OR coolant_level != 'P' OR hydraulic_valves != 'P'
-- )
-- SELECT job_id, excavator_id FROM {{ ref('jobs') }}
-- WHERE excavator_id IN (SELECT excavator_id FROM failing_excavators)
-- AND job_id IN (398, 417, 401, 332, 329, 340, 366, 373, 376, 423)

-- Which is the same as:
WITH failing_excavators AS (
    SELECT excavator_id 
    FROM excavators
    WHERE oil_level != 'P' 
       OR air_filter != 'P' 
       OR coolant_level != 'P' 
       OR hydraulic_valves != 'P'
)
SELECT job_id, excavator_id
FROM jobs
WHERE excavator_id IN (SELECT excavator_id FROM failing_excavators)
AND job_id IN (398, 417, 401, 332, 329, 340, 366, 373, 376, 423);

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- {{ ref('excavators') }} in dbt → excavators in SQL
-- {{ ref('jobs') }} in dbt → jobs in SQL
-- {{ ref('raw_excavators') }} in dbt → raw_excavators in SQL
-- {{ ref('raw_jobs') }} in dbt → raw_jobs in SQL
--
-- Model Dependency Chain:
-- raw_excavators (seed) → excavators (view)
-- raw_jobs (seed) → jobs (view)
-- excavators + jobs → maintenance (view)
-- excavators + jobs → maintenance_cte (view)
--
-- Maintenance Logic:
-- P = Pass (ready for deployment)
-- F = Fail (needs maintenance)
-- Excavator fails if ANY of: oil_level, air_filter, coolant_level, hydraulic_valves != 'P'
--
-- CTE vs UNION:
-- - maintenance.sql uses UNION for each job_id (verbose, repetitive)
-- - maintenance_cte.sql uses CTE + IN clause (cleaner, easier to maintain)
-- ============================================================================
