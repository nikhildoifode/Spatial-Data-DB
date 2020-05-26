DROP TABLE cse532.facilitycertification;

CREATE TABLE cse532.facilitycertification (
FacilityID VARCHAR(16) NOT NULL,
FacilityName VARCHAR(256),
Description VARCHAR(128),
AttributeType VARCHAR(64),
AttributeValue VARCHAR(128),
MeasureValue INT,
County VARCHAR(16),
RegionOffice VARCHAR(128)
);

load from "Health_Facility_Certification_Information.csv" of del MESSAGES load1.msg INSERT INTO cse532.facilitycertification;

DELETE FROM cse532.facilitycertification LIMIT 1;