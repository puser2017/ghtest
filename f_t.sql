##bq
WITH trips AS (
	select pickup_datetime, pickup_longitude, pickup_latitude, dropoff_longitude, dropoff_latitude
	FROM `bigquery-public-data.new_york.tlc_yellow_trips_2016`
	WHERE pickup_longitude IS NOT NULL
	AND pickup_latitude IS NOT NULL
	AND dropoff_longitude IS NOT NULL
	AND dropoff_longitude IS NOT NULL
	AND EXTRACT(MONTH FROM pickup_datetime) = 1
	LIMIT 100000
)
SELECT *
FROM trips
WHERE pickup_longitude >= -90 AND pickup_longitude < 91
AND pickup_latitude >= -90 AND pickup_latitude < 91
AND dropoff_longitude >= -90 AND dropoff_longitude < 91
AND dropoff_latitude >= -90 AND dropoff_latitude < 91
AND pickup_longitude != 0
AND dropoff_longitude != 0

##bq
WITH geo AS (
	SELECT 
		'Pickup' AS pickup_desc
		,'Dropoff' AS dropoff_desc
	  ,pickup_longitude
		,ST_GEOGPOINT(pickup_longitude, pickup_latitude) as pickup
		,ST_GEOGPOINT(dropoff_longitude, dropoff_latitude) as dropoff
--		,ST_MAKELINE(ST_GEOGPOINT(pickup_longitude, pickup_latitude), ST_GEOGPOINT(dropoff_longitude, dropoff_latitude)) As pd 
	--	,ST_CENTROID(ST_MAKELINE(ST_GEOGPOINT(pickup_longitude, pickup_latitude), ST_GEOGPOINT(dropoff_longitude, dropoff_latitude))) AS centroid
	  ,ST_DISTANCE(ST_GEOGPOINT(pickup_longitude, pickup_latitude), ST_GEOGPOINT(dropoff_longitude, dropoff_latitude)) AS distance
	FROM `formal-cascade-571.temp.tmp_sm_geo`
)
SELECT
  pickup_desc
	,dropoff_desc
	,pickup
	,dropoff
	,ST_MAKELINE(pickup, dropoff) As pd
	,distance/100 AS d
	,IF(distance/100 > 100, '#FF0000', if(distance/100 < 80, '#38761D', '#0000FF')) AS distance
FROM geo
WHERE distance/100 > 5
ORDER BY pickup_longitude

