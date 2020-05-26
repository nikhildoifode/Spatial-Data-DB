WITH NY_ZIP_FINAL as (
	select substring(NY_ZIP.ZipCode, 1, 5) as ZipCode, NY_ZIP.FacilityID as FacilityID
	from cse532.facility as NY_ZIP inner join cse532.uszip as ALL_ZIP
	on substring(NY_ZIP.ZipCode, 1, 5) = ALL_ZIP.ZCTA5CE10
),
ZIP_DB AS (
	select NY_ZIP_FINAL.ZipCode as ZipCode
	from NY_ZIP_FINAL INNER JOIN cse532.facilitycertification as FAC_INFO_DB
	on NY_ZIP_FINAL.FacilityID = FAC_INFO_DB.FacilityID
	where FAC_INFO_DB.AttributeValue = 'Emergency Department'
),
ZIP_SHAPE_DB AS (
	select ALL_ZIP.shape as shape
	from ZIP_DB INNER JOIN cse532.uszip as ALL_ZIP
	on ZIP_DB.ZipCode = ALL_ZIP.ZCTA5CE10
),
FINAL_DB AS (
	SELECT ALL_ZIP.ZCTA5CE10 as ZipCode
	FROM cse532.uszip as ALL_ZIP INNER JOIN ZIP_SHAPE_DB
	ON db2gse.st_intersects(ALL_ZIP.shape, ZIP_SHAPE_DB.shape) = 1
)

SELECT distinct NY_ZIP_FINAL.ZipCode as ZipCode
FROM NY_ZIP_FINAL LEFT JOIN FINAL_DB
ON NY_ZIP_FINAL.ZipCode = FINAL_DB.ZipCode
WHERE FINAL_DB.ZipCode IS NULL;