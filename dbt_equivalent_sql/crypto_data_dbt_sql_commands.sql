-- Active: 1768535148169@@127.0.0.1@3306@dbt_sql
-- ============================================================================
-- UNDERSTANDING DBT MODELS - CRYPTO DATA
-- ============================================================================

-- ============================================================================
-- 1. crypto_data.sql (Base Model - INCREMENTAL)
-- ============================================================================
-- The foundational model using incremental materialization.
-- Only processes new records where detail_date > max existing date.
-- In dbt:
-- {{ config(materialized='incremental') }}
-- SELECT currency, detail_date, closing_price, 24_hour_open, 24h_high_usd, 24h_low_usd
-- FROM {{ ref('raw_crypto_data') }}
-- {% if is_incremental() %}
-- WHERE detail_date > (SELECT MAX(detail_date) FROM {{ this }})
-- {% endif %}

-- What dbt creates (first run - full load):
CREATE TABLE crypto_data AS
SELECT currency, detail_date, closing_price, `24_hour_open`, `24h_high_usd`, `24h_low_usd`
FROM raw_crypto_data;

-- On subsequent runs (incremental - only new data):
INSERT INTO crypto_data
SELECT currency, detail_date, closing_price, `24_hour_open`, `24h_high_usd`, `24h_low_usd`
FROM raw_crypto_data
WHERE detail_date > (SELECT MAX(detail_date) FROM crypto_data);

-- ============================================================================
-- 2. btc.sql (Filtered Model - VIEW)
-- ============================================================================
-- Filters crypto_data to show only Bitcoin (BTC) records.
-- In dbt:
-- {{ config(materialized='view') }}
-- SELECT * FROM {{ ref('crypto_data') }} WHERE currency = 'BTC'

-- Which is the same as:
SELECT * FROM crypto_data WHERE currency = 'BTC';

-- ============================================================================
-- 3. eth.sql (Filtered Model - VIEW)
-- ============================================================================
-- Filters crypto_data to show only Ethereum (ETH) records.
-- In dbt:
-- {{ config(materialized='view') }}
-- SELECT * FROM {{ ref('crypto_data') }} WHERE currency = 'ETH'

-- Which is the same as:
SELECT * FROM crypto_data WHERE currency = 'ETH';

-- ============================================================================
-- 4. link.sql (Filtered Model - VIEW)
-- ============================================================================
-- Filters crypto_data to show only Chainlink (LINK) records.
-- In dbt:
-- {{ config(materialized='view') }}
-- SELECT * FROM {{ ref('crypto_data') }} WHERE currency = 'LINK'

-- Which is the same as:
SELECT * FROM crypto_data WHERE currency = 'LINK';

-- ============================================================================
-- 5. oxt.sql (Filtered Model - VIEW)
-- ============================================================================
-- Filters crypto_data to show only Orchid (OXT) records.
-- In dbt:
-- {{ config(materialized='view') }}
-- SELECT * FROM {{ ref('crypto_data') }} WHERE currency = 'OXT'

-- Which is the same as:
SELECT * FROM crypto_data WHERE currency = 'OXT';

-- ============================================================================
-- 6. xlm.sql (Filtered Model - VIEW)
-- ============================================================================
-- Filters crypto_data to show only Stellar Lumens (XLM) records.
-- In dbt:
-- {{ config(materialized='view') }}
-- SELECT * FROM {{ ref('crypto_data') }} WHERE currency = 'XLM'

-- Which is the same as:
SELECT * FROM crypto_data WHERE currency = 'XLM';

-- ============================================================================
-- 7. xrp.sql (Filtered Model - VIEW)
-- ============================================================================
-- Filters crypto_data to show only Ripple (XRP) records.
-- In dbt:
-- {{ config(materialized='view') }}
-- SELECT * FROM {{ ref('crypto_data') }} WHERE currency = 'XRP'

-- Which is the same as:
SELECT * FROM crypto_data WHERE currency = 'XRP';

-- ============================================================================
-- 8. btc_closing_above_3k.sql (Filtered Model - TABLE)
-- ============================================================================
-- Filters btc to show only days where BTC closed above $3,000.
-- Materialized as TABLE for faster queries.
-- In dbt:
-- {{ config(materialized='table') }}
-- SELECT * FROM {{ ref('btc') }} WHERE closing_price > 3000

-- Which is the same as:
SELECT * FROM btc WHERE closing_price > 3000;

-- ============================================================================
-- SUMMARY
-- ============================================================================
-- Model Dependency Chain:
-- raw_crypto_data (seed)
--   └── crypto_data (incremental table)
--         ├── btc (view) → btc_closing_above_3k (table)
--         ├── eth (view)
--         ├── link (view)
--         ├── oxt (view)
--         ├── xlm (view)
--         └── xrp (view)
--
-- Materialization Types Used:
-- - incremental: crypto_data (only loads new data on subsequent runs)
-- - view: btc, eth, link, oxt, xlm, xrp (live queries, no storage)
-- - table: btc_closing_above_3k (pre-computed, faster reads)
--
-- Columns in crypto_data:
-- - currency: BTC, ETH, LINK, OXT, XLM, XRP
-- - detail_date: Date of the price record
-- - closing_price: Closing price in USD
-- - 24_hour_open: Opening price for the 24h period
-- - 24h_high_usd: Highest price in 24h
-- - 24h_low_usd: Lowest price in 24h
-- ============================================================================
