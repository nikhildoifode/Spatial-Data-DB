drop index cse532.facilityidx;
drop index cse532.zipidx;
drop index cse532.SHAPEZIP_IDX;
drop index cse532.ATTRVALUE_IDX;

create index cse532.facilityidx on cse532.facility(geolocation) extend using db2gse.spatial_index(0.85, 2, 5);

create index cse532.zipidx on cse532.uszip(shape) extend using db2gse.spatial_index(0.85, 2, 5);

runstats on table cse532.facility and indexes all;

runstats on table cse532.uszip and indexes all;

CREATE INDEX cse532.SHAPEZIP_IDX ON cse532.uszip(ZCTA5CE10);

CREATE INDEX cse532.ATTRVALUE_IDX ON cse532.facilitycertification(AttributeValue);