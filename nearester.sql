WITH current_location(point) AS (
	VALUES(db2gse.st_point(-72.993983, 40.824369, 1))
),
buffer_location(geometry) AS (
	VALUES(db2gse.st_buffer(db2gse.st_point(-72.993983, 40.824369, 1), 10.0, 'STATUTE MILE'))
),
FAC_INFO_DB AS (
	SELECT FacilityID
	FROM cse532.facilitycertification
	WHERE AttributeValue = 'Emergency Department'
),
FINAL_DB AS (
	select FAC_DB.FacilityName as Name, FAC_DB.Geolocation as Location
	from cse532.facility as FAC_DB INNER JOIN FAC_INFO_DB
	on FAC_DB.FacilityID = FAC_INFO_DB.FacilityID
)

SELECT Name, cast(db2gse.ST_AsText(Location) as varchar(90)), DECIMAL(db2gse.st_distance(Location, point , 'STATUTE MILE'), 8, 4) AS distance
FROM FINAL_DB, buffer_location, current_location
WHERE db2gse.st_within(Location, geometry) = 1 
ORDER BY distance
FETCH FIRST 1 ROWS ONLY;