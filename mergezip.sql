DROP PROCEDURE cse532.MY_AGGR@

CREATE PROCEDURE cse532.MY_AGGR
LANGUAGE SQL 
MODIFIES SQL DATA

BEGIN

DECLARE SUM real;
DECLARE TEMP varchar(200);
DECLARE AVG_POP real;

select avg(ZPOP) into AVG_POP from cse532.TEMPDB;

FOR iterate_zips AS c1 CURSOR FOR (
    select ZIP as ZIP1, ZPOP as POP1, SHAPE as SHAPE1
    FROM cse532.TEMPDB
    where ZPOP < AVG_POP)
DO
    SET SUM = POP1;
    SET TEMP = ZIP1;
    DELETE FROM cse532.TEMPDB WHERE CURRENT OF c1;

    ins_loop:
    FOR iterate_zips1 AS c2 CURSOR FOR (
        select ZIP as ZIP2, ZPOP as POP2, SHAPE
        from cse532.TEMPDB
        where db2gse.st_touches(db2gse.ST_PolyFromWKB(SHAPE1), db2gse.ST_PolyFromWKB(SHAPE)) = 1)
    DO
        IF SUM > AVG_POP THEN
            LEAVE ins_loop;
        END IF;
        SET SUM = SUM + POP2;
        SET TEMP = TEMP || ',' || ZIP2;
        DELETE FROM cse532.TEMPDB WHERE CURRENT OF c2;
    END FOR;

    INSERT INTO cse532.RESULTDB VALUES(TEMP, SUM);
END FOR;

insert into cse532.RESULTDB (ZIP, ZPOP)
select ZIP, ZPOP from cse532.TEMPDB;
END@

CALL cse532.MY_AGGR()@

select avg(ZPOP) as AveragePopulation from cse532.TEMPDB@

SELECT ZIP as CombineZip, ZPOP as CombineZipPopulation FROM cse532.RESULTDB@