--Используя значения столбца STARTDATE получить дату
---------------------------------------------------------------------
--за десять дней до и после приема на работу сотрудника JOHN KLINTON:
SELECT (STARTDATE - 10) AS BEFORE10DAYS, (STARTDATE + 10) AS AFTER10DAYS FROM CAREER 
  WHERE CAREER.EMPNO = (SELECT EMPNO FROM EMP 
                          WHERE LOWER(EMP.EMPNAME) = 'john klinton');
                          
--пол года до и после приема на работу сотрудника JOHN KLINTON: 
SELECT ADD_MONTHS(STARTDATE, -6) AS BEFORE_HALF_Y, ADD_MONTHS(STARTDATE, 6) AS AFTER_HALF_Y FROM CAREER 
  WHERE CAREER.EMPNO = (SELECT EMPNO FROM EMP 
                          WHERE LOWER(EMP.EMPNAME) = 'john klinton');
                          
--год до и после приема на работу сотрудника JOHN KLINTON:
SELECT ADD_MONTHS(STARTDATE, -12) AS BEFORE_ONE_Y, ADD_MONTHS(STARTDATE, 12) AS AFTER_ONE_Y FROM CAREER 
  WHERE CAREER.EMPNO = (SELECT EMPNO FROM EMP 
                          WHERE LOWER(EMP.EMPNAME) = 'john klinton');
                          
---------------------------------------------------------------------
--Вычислите разницу в днях между датами приема на работу сотрудников JOHN MARTIN и ALEX BOUSH:

SELECT (ab.STARTDATE - jm.STARTDATE) FROM 
  (
    SELECT STARTDATE FROM CAREER 
    WHERE CAREER.EMPNO = (SELECT EMPNO FROM EMP WHERE LOWER(EMP.EMPNAME) = 'alex boush')
  ) ab, 
  (
    SELECT STARTDATE FROM CAREER 
    WHERE CAREER.EMPNO = (SELECT EMPNO FROM EMP WHERE LOWER(EMP.EMPNAME) = 'john martin')
  ) jm;

