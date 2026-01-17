{% docs pickup %}
The timestamp when the passenger(s) were picked up by the taxi. This represents the start time of the trip and is used to calculate trip duration and analyze temporal patterns in taxi demand.
{% enddocs %}

{% docs dropoff %}
The timestamp when the passenger(s) were dropped off at their destination. This represents the end time of the trip and is used along with pickup time to calculate trip duration.
{% enddocs %}

{% docs passengers %}
The total number of passengers in the taxi during the trip. This value typically ranges from 1 to 6 passengers and helps analyze capacity utilization and group travel patterns.
{% enddocs %}

{% docs distance %}
The total distance traveled during the trip, measured in miles. This metric is crucial for fare calculation, route analysis, and understanding trip characteristics.
{% enddocs %}

{% docs fare %}
The base fare charged for the trip, calculated based on distance and time. This does not include tips, tolls, or other surcharges. The fare is the primary revenue component of each trip.
{% enddocs %}

{% docs tip %}
The gratuity amount given to the driver by the passenger. Tips are optional and typically represent a percentage of the fare amount. This field helps analyze customer satisfaction and tipping behaviors.
{% enddocs %}

{% docs tolls %}
The total amount of road tolls paid during the trip. This includes bridge tolls, tunnel tolls, and other infrastructure fees that vary by route taken.
{% enddocs %}

{% docs total %}
The complete amount paid for the trip, calculated as the sum of fare + tip + tolls + any other surcharges. This represents the total revenue generated from the trip.
{% enddocs %}

{% docs color %}
The vehicle color or medallion type of the taxi. Common values include 'yellow' for traditional NYC taxis and 'green' for outer-borough taxis. This helps distinguish between different taxi service types.
{% enddocs %}

{% docs payment %}
The payment method used by the passenger to pay for the trip. Common values include 'Credit card', 'Cash', and other digital payment methods. This helps analyze payment preferences and trends.
{% enddocs %}

{% docs pickup_zone %}
The specific taxi zone where the passenger was picked up. NYC is divided into multiple taxi zones for tracking and analysis purposes. This granular location data enables detailed geographic analysis of trip origins.
{% enddocs %}

{% docs dropoff_zone %}
The specific taxi zone where the passenger was dropped off. This granular location data enables detailed geographic analysis of trip destinations and helps identify popular dropoff locations.
{% enddocs %}

{% docs pickup_borough %}
The NYC borough where the trip originated. The five boroughs are: Manhattan, Brooklyn, Queens, The Bronx, and Staten Island. This provides a high-level geographic grouping for trip analysis.
{% enddocs %}

{% docs dropoff_borough %}
The NYC borough where the trip ended. The five boroughs are: Manhattan, Brooklyn, Queens, The Bronx, and Staten Island. This helps analyze inter-borough travel patterns and destination preferences.
{% enddocs %}

{% docs credit_card_count_column %}
The total count of trips paid using credit card payment method.
{% enddocs %}

{% docs avg_num_passengers_manhattan_column %}
The average (mean) number of passengers per trip for all trips ending in Manhattan.
{% enddocs %}

{% docs taxi_trips_model %}
# Taxi Trips - Base Model

This is the foundational model that contains all taxi trip data loaded from the raw seed file. It serves as the source for all downstream models and includes comprehensive trip information including:

- **Temporal data**: Pickup and dropoff timestamps
- **Trip metrics**: Distance, duration, passenger count
- **Financial data**: Fare, tips, tolls, total amount
- **Location data**: Pickup and dropoff zones and boroughs
- **Trip attributes**: Vehicle color, payment method

This model is materialized as a **view** and references the `raw_taxi_trips` seed table.

**Downstream models**: All analytical models reference this base model using `ref('taxi_trips')`.
{% enddocs %}

{% docs over_nine_miles_model %}
# Over Nine Miles - Filtered Trips

This model filters the taxi trips data to include only trips where the distance traveled exceeds 9 miles. These long-distance trips represent:

- Airport trips (e.g., to JFK, LaGuardia, Newark)
- Inter-borough travel to outer areas
- Longer journeys typically with higher fares

**Use cases**:
- Analyze long-distance trip characteristics
- Study fare patterns for extended trips
- Identify popular long-distance routes
- Calculate average revenue for long trips

**Filter logic**: `WHERE distance > 9`

This model is materialized as a **view** and depends on the `taxi_trips` model.
{% enddocs %}

{% docs cross_borough_model %}
# Cross-Borough Trips

This model identifies trips that cross borough boundaries - where the pickup borough and dropoff borough are different. These trips are particularly interesting for:

- Understanding commuter patterns between boroughs
- Analyzing inter-borough transportation demand
- Studying longer trips that typically have higher fares
- Identifying the most common borough-to-borough routes

**Examples of cross-borough trips**:
- Brooklyn → Manhattan (common commuter route)
- Queens → Manhattan (airport and commuter traffic)
- Manhattan → Brooklyn (reverse commute, entertainment)

**Filter logic**: `WHERE pickup_borough <> dropoff_borough`

This model is materialized as a **view** and depends on the `taxi_trips` model.
{% enddocs %}

{% docs credit_card_count_model %}
# Credit Card Payment Count

This aggregation model calculates the total number of trips paid using credit card. It provides a simple metric to:

- Track electronic payment adoption rates
- Compare credit card usage against cash and other payment methods
- Monitor payment method trends over time

**Aggregation logic**:
```sql
SELECT payment, COUNT(payment) AS credit_card_count
FROM taxi_trips
WHERE payment = 'Credit card'
GROUP BY payment
```

This model returns a **single row** with the payment type and count.

This model is materialized as a **view** and depends on the `taxi_trips` model.
{% enddocs %}

{% docs avg_num_dropoff_manhattan_model %}
# Average Passengers - Manhattan Dropoffs

This aggregation model calculates the average number of passengers for all trips that end in Manhattan. This metric helps understand:

- Typical group sizes traveling to Manhattan
- Capacity utilization for Manhattan-bound trips
- Differences in passenger counts between destinations

Manhattan is the most common destination borough and a major employment/entertainment center, making this metric valuable for:
- Service planning and capacity forecasting
- Understanding commuter vs. leisure travel patterns
- Comparing with other boroughs

**Aggregation logic**:
```sql
SELECT AVG(passengers) AS avg_num_passengers_manhattan
FROM taxi_trips
WHERE dropoff_borough = 'Manhattan'
```

This model returns a **single row** with the average passenger count.

This model is materialized as a **view** and depends on the `taxi_trips` model.
{% enddocs %}