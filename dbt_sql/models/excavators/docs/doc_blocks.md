{% docs excavator_id %}
The unique identifier for each excavator in the company's fleet. This ID is used to track equipment across jobs, maintenance records, and operational assignments.
{% enddocs %}

{% docs job_id %}
The unique identifier for each job or project. Jobs represent work assignments where excavators are deployed to specific locations under a manager's supervision.
{% enddocs %}

{% docs city %}
The city where the job is located. This geographic information helps track equipment deployment and regional operations.
{% enddocs %}

{% docs manager %}
The name of the manager responsible for overseeing the job. Managers are accountable for equipment usage and job completion at their assigned sites.
{% enddocs %}

{% docs oil_level %}
Pass/Fail indicator for the excavator's oil level inspection. 'P' indicates the oil level is acceptable, 'F' indicates it needs attention before the excavator can be deployed.
{% enddocs %}

{% docs air_filter %}
Pass/Fail indicator for the excavator's air filter condition. 'P' indicates the air filter is clean and functional, 'F' indicates it requires replacement or cleaning.
{% enddocs %}

{% docs coolant_level %}
Pass/Fail indicator for the excavator's coolant level inspection. 'P' indicates adequate coolant for safe operation, 'F' indicates the coolant needs to be topped up or replaced.
{% enddocs %}

{% docs hydraulic_valves %}
Pass/Fail indicator for the excavator's hydraulic valve inspection. 'P' indicates the hydraulic system is functioning properly, 'F' indicates maintenance is required before operation.
{% enddocs %}

{% docs excavators_model %}
# Excavators - Base Model

This is the foundational model containing all excavator equipment data. It tracks the maintenance status of each excavator in the company's fleet.

**Columns selected**:
- excavator_id: Unique identifier for each excavator
- oil_level: P/F maintenance indicator
- air_filter: P/F maintenance indicator
- coolant_level: P/F maintenance indicator
- hydraulic_valves: P/F maintenance indicator

An excavator is considered **ready for deployment** when all four indicators are 'P' (Pass).

This model is materialized as a **view** and references the `raw_excavators` seed table.
{% enddocs %}

{% docs jobs_model %}
# Jobs - Base Model

This model contains all job assignments where excavators are deployed. Each job represents a work site with an assigned excavator and manager.

**Columns selected**:
- job_id: Unique job identifier
- excavator_id: The excavator assigned to this job
- city: Job location
- manager: Person responsible for the job

This model is materialized as a **view** and references the `raw_jobs` seed table.
{% enddocs %}

{% docs maintenance_model %}
# Maintenance - Failing Excavators by Job

This model identifies excavators that are **not ready** for specific jobs. An excavator fails the maintenance check if any of its four indicators (oil_level, air_filter, coolant_level, hydraulic_valves) is not 'P'.

**Logic**: Uses UNION statements to check specific job IDs (398, 417, 401, 332, 329, 340, 366, 373, 376, 423) against excavators with failing maintenance indicators.

**Use cases**:
- Identify which jobs have equipment that needs maintenance
- Prevent deployment of unsafe equipment
- Track maintenance compliance across job sites

This model is materialized as a **view** and depends on `jobs` and `excavators` models.
{% enddocs %}

{% docs maintenance_cte_model %}
# Maintenance CTE - Cleaner Implementation

This model is a **refactored version** of the maintenance model using Common Table Expressions (CTEs) for better readability and maintainability.

**CTE Structure**:
```sql
WITH failing_excavators AS (
    SELECT excavator_id FROM excavators
    WHERE oil_level != 'P' OR air_filter != 'P' 
       OR coolant_level != 'P' OR hydraulic_valves != 'P'
)
SELECT job_id, excavator_id FROM jobs
WHERE excavator_id IN (SELECT excavator_id FROM failing_excavators)
  AND job_id IN (398, 417, 401, 332, 329, 340, 366, 373, 376, 423)
```

**Advantages over UNION approach**:
- Single subquery instead of repeated UNION blocks
- Easier to maintain and modify job ID list
- More efficient query execution

This model is materialized as a **view** and depends on `jobs` and `excavators` models.
{% enddocs %}
