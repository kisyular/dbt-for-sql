-- cross_borough: All columns with taxi trip start in one borough, but end up in another.
SELECT
    *
FROM {{ ref('taxi_trips') }} -- this came from the table retutned in the model taxi_trips
WHERE pickup_borough <> dropoff_borough;