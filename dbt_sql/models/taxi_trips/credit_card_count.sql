-- credit_card_count: Breakdown of the count of fares paid by credit card.
SELECT
    payment,
    COUNT(payment) AS credit_card_count
FROM {{ ref('taxi_trips') }}
WHERE payment= 'Credit card'