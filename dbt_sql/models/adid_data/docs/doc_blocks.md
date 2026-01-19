{% docs adid %}
The advertising ID (ADID) for this data point. This is a unique identifier assigned to mobile devices for advertising purposes. Every value in this column should be a distinct ad_id, enabling tracking of user engagement across advertising campaigns.
{% enddocs %}

{% docs latitude %}
The latitude coordinate of the data point location. This geographic coordinate specifies the north-south position and is used for location-based advertising analysis and geospatial queries.
{% enddocs %}

{% docs longitude %}
The longitude coordinate of the data point location. This geographic coordinate specifies the east-west position and together with latitude enables precise location mapping for advertising data.
{% enddocs %}

{% docs adid_city %}
The city where the advertising data point was recorded. This geographic classification helps analyze advertising reach and user distribution across different urban areas worldwide.
{% enddocs %}

{% docs eventdate %}
The date when the advertising event was recorded. This timestamp enables time-series analysis of advertising data, tracking campaign performance over time, and identifying temporal patterns in user engagement.
{% enddocs %}

{% docs cohort %}
The cohort classification for the advertising ID. Cohorts group users for A/B testing, campaign segmentation, and behavioral analysis. There are 6 cohorts: 'one', 'two', 'three', 'four', 'five', and 'six'. Each cohort should have a maximum of 110 distinct ADIDs.
{% enddocs %}

{% docs adid_data_model %}
# ADID Data - Base Model

This is the foundational model containing advertising ID (ADID) data for mobile advertising analytics. It tracks user locations and cohort assignments for advertising campaign analysis.

**Columns selected**:
- adid: Unique advertising identifier for each device
- latitude: Geographic latitude coordinate
- longitude: Geographic longitude coordinate
- city: City where the event was recorded
- eventdate: Date of the advertising event
- cohort: User cohort classification (one through six)

**Use cases**:
- Location-based advertising analysis
- Cohort performance comparison
- Geographic distribution of ad impressions
- Time-series analysis of advertising events

This model is materialized as a **view** and references the `raw_adid_data` seed table.

**Data Quality**:
- Each ADID should be unique
- All fields are required (not_null)
- Cohort values must be: 'one', 'two', 'three', 'four', 'five', or 'six'
- Custom test ensures each cohort has maximum 100 distinct ADIDs
{% enddocs %}
