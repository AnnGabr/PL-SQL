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

---------------------------------------------------------------------
--Требуется найти разность между двумя датами в месяцах и в годах:
SELECT TRUNC(ABS(MONTHS_BETWEEN(TO_DATE ('2003/01/01', 'yyyy/mm/dd'), TO_DATE ('2003/03/14', 'yyyy/mm/dd')))) AS RESULT FROM DUAL;
SELECT TRUNC(ABS(MONTHS_BETWEEN(TO_DATE('2005/01/01', 'yyyy/mm/dd'), TO_DATE('2003/01/01', 'yyyy/mm/dd'))/12)) AS RESULT FROM DUAL;

---------------------------------------------------------------------
--Для каждого сотрудника 20-го отдела найти сколько дней прошло между датой его приема на работу 
--и датой приема на работу следующего сотрудника:
SELECT STARTDATE, MONTHS_BETWEEN(LEAD(STARTDATE, 1) over (ORDER BY STARTDATE), STARTDATE) MONTHS_TO_NEXT 
  FROM CAREER 
  WHERE DEPTNO = 20 
  ORDER BY STARTDATE;

---------------------------------------------------------------------
--Требуется подсчитать количество дней в году по столбцу START_DATE:
SELECT STARTDATE YEAR, ADD_MONTHS(TRUNC(STARTDATE, 'YEAR'), 12) - TRUNC(STARTDATE, 'YEAR') DAYS FROM CAREER ORDER BY STARTDATE;

---------------------------------------------------------------------
--Pазложить текущую дату на день, месяц, год, секунды, минуты, часы. Результаты вернуть в численном виде:
SELECT extract(year from sysdate) YEAR, 
       extract(month from sysdate) MONTH, 
       extract(day from sysdate) DAY, 
       to_number(to_char(sysdate, 'hh24')) H, 
       to_char(sysdate, 'mi') M, 
       to_char(sysdate, 'ss') S 
 FROM dual;
 
---------------------------------------------------------------------
--Требуется получить первый и последний дни текущего месяца:
SELECT sysdate, extract(day from LAST_DAY(sysdate)) LAST_DAY FROM DUAL;

---------------------------------------------------------------------
--Bозвратить даты начала и конца каждого из четырех кварталов данного года:
SELECT 
  TRUNC(SYSDATE, 'YEAR') s_1, 
    LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), 2)) e_1, 
  ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), 3) s_2, 
    LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), 5)) e_2,
  ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), 6) s_3, 
    LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), 8)) e_3,
  ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), 9) s_4, 
    LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), 11)) e_4
FROM DUAL;
---------------------------------------------------------------------
--Сформируйте список понедельников текущего года:
---------------------------------------------------------------------
--Cоздать календарь на текущий месяц. Календарь должен иметь семь столбцов в ширину и пять строк вниз:


  

