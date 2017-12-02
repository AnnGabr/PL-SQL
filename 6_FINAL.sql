--1. simple CASE ():
---------------------------------------------
 SELECT NAME, BIRTH_DATE,
    CASE LOWER(GENDER)
        WHEN 'm' THEN 'MALE'
        WHEN 'f' THEN 'FEMALE'
        ELSE 'N/A'
    END GENDER
    FROM HORSES;
    
--2. search CASE():
---------------------------------------------
SELECT NAME, WEIGHT, HEIGHT,
    CASE
        WHEN WEIGHT/HEIGHT/HEIGHT*10000 < 25 AND WEIGHT/HEIGHT/HEIGHT*10000 > 20
            THEN 'IN NORM'
        ELSE 'NOT IN NORM'
    END BODY_MASS_INDEX
    FROM JOCKEYS;
    
--3. WITH():
---------------------------------------------
WITH FIRST_PLACES AS (
SELECT HORSE_ID FROM RESULTS WHERE ARRIVAL_NUMBER = 1 )
SELECT DISTINCT(HORSES.NAME) WHERE_FIRST 
    FROM FIRST_PLACES RIGHT JOIN HORSES ON HORSES.HORSE_ID = FIRST_PLACES.HORSE_ID;
    
--4. встроенное представление():
---------------------------------------------
SELECT DISTINCT(OWNERS.NAME) HIS_HORSE_WHERE_FIRST 
    FROM ( SELECT HORSES.OWNER_ID FROM RESULTS RIGHT 
             JOIN HORSES ON HORSES.HORSE_ID = RESULTS.HORSE_ID 
             WHERE RESULTS.ARRIVAL_NUMBER = 1) 
    RIGHT JOIN OWNERS USING(OWNER_ID);

--5. некоррелированный запрос:
---------------------------------------------
SELECT NAME MORE_THEN_35_YEARS FROM JOCKEYS WHERE MONTHS_BETWEEN (SYSDATE, BIRTH_DATE) / 12 > 35;

--6. коррелированный запрос:
---------------------------------------------
SELECT NAME, WEIGHT, HEIGHT FROM JOCKEYS ONE WHERE WEIGHT > (SELECT AVG(WEIGHT) FROM JOCKEYS WHERE HEIGHT = ONE.HEIGHT);

--7. NULLIF:
---------------------------------------------
SELECT NAME, WEIGHT, HEIGHT, BIRTH_DATE, NULLIF(HEIGHT, 182) NULL_IF_182 FROM JOCKEYS;

--8. NVL2:
---------------------------------------------
SELECT NVL2(NAME, NAME, 'NO MATTER') COMP_NAME FROM COMPETITIONS;

--9. TOP-N анализ():
---------------------------------------------

--10. ROLLUP():
---------------------------------------------

--11. MERGE:
---------------------------------------------

