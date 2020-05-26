DROP TABLE cse532.ZIPPOP;
DROP TABLE cse532.TEMPDB;
DROP TABLE cse532.RESULTDB;

CREATE TABLE cse532.ZIPPOP (
	ZIP int NOT NULL UNIQUE,
	COUNTY int,
	GEOID int,
	ZPOP real NOT NULL
);

load from "nyzip.csv" of del MESSAGES load2.msg INSERT INTO cse532.ZIPPOP;

CREATE TABLE cse532.TEMPDB (
	ZIP varchar(6),
	ZPOP real
	SHAPE BLOB(2G)
) COMPRESS YES;

CREATE TABLE cse532.RESULTDB (
	ZIP varchar(200),
	ZPOP real
);

insert into cse532.TEMPDB (ZIP, ZPOP, SHAPE)
select cast(z.zip as varchar(6)), z.ZPOP, db2gse.ST_AsShape(s.shape)
from cse532.ZIPPOP as z INNER JOIN cse532.uszip as s
on z.ZIP = cast(s.ZCTA5CE10 as int)
where z.ZPOP > 0
order by z.ZPOP;
