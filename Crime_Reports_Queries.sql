/*
  QUERY 1: Top 10 Car Owners
  OBJECTIVE: Identify individuals with the highest number of registered vehicles.
  TABLES USED: individuals (i), cars (c)
*/
SELECT 
    i.id AS individual_id, 
    (i.first_name || ' ' || i.last_name) AS owner, 
    COUNT(c.id) AS cars_owned
FROM individuals i
JOIN cars c ON i.id = c.individual_id
GROUP BY i.id, owner
ORDER BY cars_owned DESC
LIMIT 10;

/*
  QUERY 2: Fleet owners 
  OBJECTIVE: Identify multi-vehicle owners (4 or more cars).
  TABLES USED: individuals (i), cars (c)
*/
SELECT
    i.id AS individual_id,
	i.first_name, 
	i.last_name,
    COUNT (c.id) AS cars_owned
FROM individuals i
JOIN cars c ON i.id = c.individual_id
GROUP BY i.id, i.first_name, i.last_name
HAVING cars_owned > 3
ORDER BY cars_owned DESC;

/*
  QUERY 3: Recent Missing car reports.
  OBJECTIVE:Retrieve the profiles of reporters; individuals associated with the most recent missing car reports.
  TABLES USED: reports (r), individuals (i), cars (c), locations (l)
*/
SELECT 
    r.id AS report_id, r.reported_at, r.status,
	c.plate, c.make, c.model,
	i.first_name, i.last_name,
    l.name AS last_seen_location
FROM reports r
JOIN cars c ON r.car_id = c.id
JOIN individuals i ON c.individual_id = i.id
JOIN locations l ON r.last_seen_location_id = l.id
ORDER BY reported_at Desc
LIMIT 20;

/*
  QUERY 4: Report count
  OBJECTIVE:Retrieve how many times each crime is reported
  TABLES USED: reports (r)
*/
SELECT 
    status,
	count(status) AS reports_count
FROM reports
GROUP BY status
ORDER BY reports_count DESC;

/*
  QUERY 5: Investigator details
  OBJECTIVE:Retrieve profile of each investigator
  TABLES USED: investigators(i), reports (r), locations (l)
*/
SELECT
    i.id, i.first_name, i.last_name,
	count(investigator_id) AS assigned_reports,
	l.name AS jurisdiction
FROM investigators i
JOIN reports r on i.id = r.investigator_id
JOIN locations l on i.jurisdiction_location_id = l.id
GROUP BY i.id,i.first_name, i.last_name,l.name
ORDER BY assigned_reports DESC;

/*
  QUERY 6: Status report
  OBJECTIVE:Retrieves the most recent status report for each car.
  TABLES USED:reports (r)
  Used ROW_NUMBER () to rank reports by date per car and filter newest record
  */
WITH latest_report_date AS (
    SELECT
        id AS report_id,
        car_id,
        reported_at,
        status,
        ROW_NUMBER() OVER(PARTITION BY car_id ORDER BY reported_at DESC) AS rd
    FROM reports
)
SELECT
    report_id,
    car_id,
    reported_at,
    status
FROM latest_report_date
WHERE rd = 1
ORDER BY reported_at DESC;

/*
  QUERY 7: Reports count
  OBJECTIVE:Retrieves average distance from reporter and number of reports per report status class.
  TABLES USED:reports (r)
  */
  SELECT
      status,
	  round (avg (distance_from_owner_km),2) AS avg_distance_km,
	  count (status) AS reports_count
FROM reports
GROUP BY status
ORDER BY avg_distance_km DESC;

/* Q8: Owner profile
OBJECTIVE: Retrieves individuals with more than one report
TABLES USED: individuals(i), cars(c)
*/
SELECT 
    i.id AS owner_id,
    i.first_name, 
	i.last_name,
    count (*) AS total_reports
FROM individuals i
JOIN cars c on i.id = c.individual_id
JOIN reports r on c.id = r.car_id
GROUP BY i.id, i.first_name, i.last_name 
HAVING  count (*) > 1
ORDER BY total_reports DESC,owner_id Desc;


/* Q9: Top 3 reported plate numbers by location 
OBJECTIVE: Retrieves the top 3 reports by plate numbers in each location
TABLES USED: reports(r) and location(l)*/
WITH counts AS (
  SELECT l.name AS location, c.plate, COUNT(*) AS reports_count
  FROM reports r
  JOIN cars c ON r.car_id = c.id
  JOIN locations l ON r.last_seen_location_id = l.id
  GROUP BY l.name, c.plate
),
ranked AS (
  SELECT location, plate, reports_count,
         ROW_NUMBER() OVER (PARTITION BY location ORDER BY reports_count DESC) AS rn
  FROM counts
)
SELECT location, plate, reports_count
FROM ranked
WHERE rn <= 3
ORDER BY location, reports_count DESC;

/*Q10: Report profile
OBJECTIVE: Retrieves every report assigned to each investigators
TABLES USED: investigators(i), reports(r), locations(l)*/
WITH latest_investigator AS (
    SELECT
        i.id AS investigator_id,
        (i.first_name || ' ' || i.last_name) AS investigator,
	    r.id AS report_id,
	    reported_at,
	    l.name AS jurisdiction,
        ROW_NUMBER() OVER(PARTITION BY i.id ORDER BY reported_at DESC) AS li
    FROM investigators i
    JOIN reports r on i.id = r.investigator_id
    JOIN locations l on r.last_seen_location_id = l.id
)
SELECT
    investigator_id,
    investigator,
	report_id,
	reported_at,
	jurisdiction
FROM latest_investigator
WHERE li = 1
ORDER BY investigator;


