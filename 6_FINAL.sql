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
SELECT NAME, WEIGHT, HEIGHT FROM JOCKEYS ONE WHERE WEIGHT > (SELECT AVG(WEIGHT) FROM JOCKEYS);

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
SELECT NAME HIGHEST_5, HEIGHT
FROM   (SELECT *
        FROM   JOCKEYS
        ORDER BY HEIGHT DESC)
WHERE ROWNUM <= 5;

--10. ROLLUP():
---------------------------------------------
SELECT HEIGHT, AVG(WEIGHT) AVG_WEIGHT FROM JOCKEYS GROUP BY ROLLUP (HEIGHT) ORDER BY HEIGHT;

--11. MERGE:
---------------------------------------------
CREATE TABLE TEMP_HIP (
   ID        INTEGER PRIMARY KEY,
   NAME      VARCHAR2(40) NOT NULL,
   OWNER_ID  INTEGER NOT NULL CHECK(OWNER_ID > 0));

INSERT INTO TEMP_HIP VALUES
    (1, 'HOLWOOD', 1);
INSERT INTO TEMP_HIP VALUES
    (3, 'VARLEY', 2);

MERGE INTO HIPPODROME H
    USING (SELECT * FROM TEMP_HIP) H_T
        ON (H.HIP_ID = H_T.ID) 
   WHEN MATCHED THEN
        UPDATE SET H.NAME = H_T.NAME
        AND H.OWNER_ID=H_T.OWNER_ID
    WHEN NOT MATCHED THEN
        INSERT (H.HIP_ID, H.NAME, H.OWNER_ID)
        VALUES (H_T.ID, H_T.NAME, H_T.OWNER_ID);
