--1. simple CASE ():
---------------------------------------------
 SELECT NAME, BIRTH_DATE,
    CASE LOWER(GENDER)
        WHEN 'm' THEN 'MALE'
        WHEN 'f' THEN 'FEMALE'
        ELSE 'N/A'
    END GENDER
    FROM HORSES
    
--2. search CASE():
---------------------------------------------
SELECT NAME, WEIGHT, HEIGHT,
    CASE
        WHEN WEIGHT/HEIGHT/HEIGHT*10000 < 25 AND WEIGHT/HEIGHT/HEIGHT*10000 > 20
            THEN 'IN NORM'
        ELSE 'NOT IN NORM'
    END BODY_MASS_INDEX
    FROM JOCKEYS
    
--3. WITH():

--4. встроенное представление():
--5. некоррелированный запрос:
(academy.oracle.com\iLearning\2013-2014 Oracle Academy Database Programming with SQL – Student\Section 6 Creating Subqueries);
--6. коррелированный запрос:
(academy.oracle.com\iLearning\2013-2014 Oracle Academy Database Programming with SQL – Student\Section 6 Creating Subqueries).);
--7. NULLIF:
(academy.oracle.com\iLearning\2013-2014 Oracle Academy Database Programming with SQL – Student\Section 2 Using Single-Row Functions);
--8. NVL2:
(academy.oracle.com\iLearning\2013-2014 Oracle Academy Database Programming with SQL – Student\Section 2 Using Single-Row Functions);
--9. TOP-N анализ():

--10. ROLLUP():

--11. MERGE:

