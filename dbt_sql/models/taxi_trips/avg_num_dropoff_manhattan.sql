-- avg_num_dropoff_manhattan: Average number of passengers on all trips which end in Manhattan
SELECT
    AVG(passengers) AS avg_num_passengers_manhattan
FROM {{ ref('taxi_trips') }}
WHERE dropoff_borough = 'Manhattan';