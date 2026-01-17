{% docs currency %}
The cryptocurrency ticker symbol identifying the digital asset. Values include BTC (Bitcoin), ETH (Ethereum), LINK (Chainlink), OXT (Orchid), XLM (Stellar Lumens), and XRP (Ripple). This is the primary identifier for filtering and grouping price data.
{% enddocs %}

{% docs detail_date %}
The date of the price record. This timestamp represents when the price data was captured and is used for time-series analysis, trend identification, and historical price tracking.
{% enddocs %}

{% docs closing_price %}
The closing price of the cryptocurrency in USD at the end of the trading period. This is the most commonly referenced price point for daily analysis and is used to calculate returns and price changes.
{% enddocs %}

{% docs hour_24_open %}
The opening price of the cryptocurrency in USD at the start of the 24-hour trading period. Used with closing_price to calculate daily price movement and percentage changes.
{% enddocs %}

{% docs high_24h_usd %}
The highest price reached by the cryptocurrency in USD during the 24-hour trading period. This represents the peak value and is used to calculate volatility and trading ranges.
{% enddocs %}

{% docs low_24h_usd %}
The lowest price reached by the cryptocurrency in USD during the 24-hour trading period. This represents the floor value and is used alongside the high to measure daily volatility.
{% enddocs %}

{% docs crypto_data_model %}
# Crypto Data - Base Model (Incremental)

This is the foundational model that contains all cryptocurrency price data loaded from the raw seed file. It uses **incremental materialization** for efficient data loading.

**Columns selected**:
- currency: Cryptocurrency ticker (BTC, ETH, LINK, OXT, XLM, XRP)
- detail_date: Date of the price record
- closing_price: Closing price in USD
- 24_hour_open: Opening price for the 24h period
- 24h_high_usd: Highest price in 24h
- 24h_low_usd: Lowest price in 24h

**Incremental logic**: On subsequent runs, only loads records where `detail_date > max(existing dates)`.

**Downstream models**: All currency-specific models reference this base model using `ref('crypto_data')`.
{% enddocs %}

{% docs btc_model %}
# BTC - Bitcoin Price Data

This model filters the crypto_data to include only Bitcoin (BTC) records. Bitcoin is the original and largest cryptocurrency by market capitalization.

**Use cases**:
- Analyze Bitcoin price trends over time
- Calculate BTC-specific metrics and returns
- Compare Bitcoin performance against other cryptocurrencies

**Filter logic**: `WHERE currency = 'BTC'`

This model is materialized as a **view** and depends on the `crypto_data` model.
{% enddocs %}

{% docs eth_model %}
# ETH - Ethereum Price Data

This model filters the crypto_data to include only Ethereum (ETH) records. Ethereum is the second-largest cryptocurrency and powers smart contracts and DeFi applications.

**Use cases**:
- Track Ethereum price movements
- Analyze ETH performance during DeFi and NFT market cycles
- Compare against Bitcoin and other altcoins

**Filter logic**: `WHERE currency = 'ETH'`

This model is materialized as a **view** and depends on the `crypto_data` model.
{% enddocs %}

{% docs link_model %}
# LINK - Chainlink Price Data

This model filters the crypto_data to include only Chainlink (LINK) records. Chainlink provides decentralized oracle services connecting smart contracts to real-world data.

**Use cases**:
- Monitor LINK price trends
- Analyze oracle token performance
- Track DeFi infrastructure token valuations

**Filter logic**: `WHERE currency = 'LINK'`

This model is materialized as a **view** and depends on the `crypto_data` model.
{% enddocs %}

{% docs oxt_model %}
# OXT - Orchid Price Data

This model filters the crypto_data to include only Orchid (OXT) records. Orchid is a decentralized VPN service powered by cryptocurrency payments.

**Use cases**:
- Track OXT price movements
- Analyze privacy-focused token performance
- Monitor smaller-cap altcoin trends

**Filter logic**: `WHERE currency = 'OXT'`

This model is materialized as a **view** and depends on the `crypto_data` model.
{% enddocs %}

{% docs xlm_model %}
# XLM - Stellar Lumens Price Data

This model filters the crypto_data to include only Stellar Lumens (XLM) records. Stellar is a payment network focused on cross-border transactions and financial inclusion.

**Use cases**:
- Monitor XLM price trends
- Analyze payment-focused cryptocurrency performance
- Track remittance and cross-border payment token valuations

**Filter logic**: `WHERE currency = 'XLM'`

This model is materialized as a **view** and depends on the `crypto_data` model.
{% enddocs %}

{% docs xrp_model %}
# XRP - Ripple Price Data

This model filters the crypto_data to include only Ripple (XRP) records. XRP is designed for fast, low-cost international payments and is used by financial institutions.

**Use cases**:
- Track XRP price movements
- Analyze institutional payment token performance
- Monitor regulatory impact on price

**Filter logic**: `WHERE currency = 'XRP'`

This model is materialized as a **view** and depends on the `crypto_data` model.
{% enddocs %}

{% docs btc_closing_above_3k_model %}
# BTC Closing Above $3,000

This model filters Bitcoin data to show only days where BTC closed above $3,000. This threshold represents a significant price level in Bitcoin's history.

**Use cases**:
- Analyze Bitcoin behavior above key price levels
- Study bull market characteristics
- Filter out early low-price historical data

**Filter logic**: `WHERE closing_price > 3000`

This model is materialized as a **table** for faster queries and depends on the `btc` model.
{% enddocs %}
