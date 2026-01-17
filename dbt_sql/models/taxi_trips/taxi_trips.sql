-- select all rows and columns from raw_taxi_trips
SELECT *
FROM {{ ref('raw_taxi_trips') }}