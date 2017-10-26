-------------------------------------------------
--ПРОСТЕЙШИЕ ЗАПРОСЫ: ///////////////////////////
-------------------------------------------------
--Выдать информацию о местоположении отдела продаж (SALES) компании.
SELECT DEPTADDR FROM DEPT WHERE LOWER(DEPTNAME) = 'sales';
--Выдать информацию об отделах, расположенных в Chicago и New York.
SELECT * FROM DEPT WHERE LOWER(DEPTADDR) IN ('new york', 'chicago');
-------------------------------------------------
--ФУНКЦИИ: //////////////////////////////////////
-------------------------------------------------
--Найти минимальную заработную плату, начисленную в 2009 году.
SELECT MIN(SALVALUE) FROM SALARY WHERE YEAR = 2009;
--Выдать информацию обо всех работниках, родившихся не позднее 1 января 1960 года.
SELECT * FROM EMP WHERE BIRTHDATE <= to_date('01.01.1960','dd.mm.yyyy');
--Подсчитать число работников, сведения о которых имеются в базе данных .
SELECT COUNT(*) FROM EMP;
--Найти работников, чьё имя состоит из одного слова. Имена выдать на нижнем регистре, с удалением стоящей справа буквы t.
SELECT REGEXP_REPLACE(LOWER(EMPNAME), 't$') NAME FROM EMP WHERE EMPNAME NOT LIKE('% %');
--Выдать информацию о работниках, указав дату рождения в формате день(число), месяц(название), год(название). 
SELECT EMPNO, TO_CHAR( BIRTHDATE, 'dd-MONTH-YEAR') BIRTHDATE, EMPNAME, MANAGER_ID FROM EMP;
--Тоже, но год числом.
SELECT EMPNO, TO_CHAR( BIRTHDATE, 'dd-MONTH-yyyy') BIRTHDATE, EMPNAME, MANAGER_ID FROM EMP;
--Выдать информацию о должностях, изменив названия должности “CLERK” и “DRIVER” на “WORKER”.
SELECT JOBNO, REGEXP_REPLACE(JOBNAME, 'CLERK|DRIVER', 'WORKER') NEWJOBNAME, MINSALARY FROM JOB;
-------------------------------------------------
--HAVING: ///////////////////////////////////////
-------------------------------------------------
--Определите среднюю зарплату за годы, в которые были начисления не менее чем за три месяца.
SELECT YEAR, AVG(SALVALUE) AVG_SALEVALUE FROM SALARY GROUP BY YEAR HAVING COUNT(MONTH) > 2;
-------------------------------------------------
--СОЕДИНЕНИЕ ПО РАВЕНСТВУ: //////////////////////
-------------------------------------------------
--Выведете ведомость получения зарплаты с указанием имен служащих.
SELECT EMP.EMPNAME, SALARY.SALVALUE, SALARY.MONTH, SALARY.YEAR FROM EMP, SALARY WHERE EMP.EMPNO=SALARY.EMPNO; 	
-------------------------------------------------
--СОЕДИНЕНИЕ НЕ ПО РАВЕНСТВУ: ///////////////////
-------------------------------------------------
--Укажите  сведения о начислении сотрудникам зарплаты, попадающей в вилку: минимальный оклад по должности - минимальный оклад по должности плюс пятьсот. Укажите соответствующую вилке  должность.
SELECT EMP.EMPNAME, JOB.JOBNAME, SALARY.SALVALUE
    FROM SALARY 
	INNER JOIN EMP 
	    ON SALARY.EMPNO = EMP.EMPNO 
	INNER JOIN CAREER 
	    ON CAREER.EMPNO = EMP.EMPNO 
	INNER JOIN JOB 
	    ON JOB.JOBNO = CAREER.JOBNO
	WHERE SALARY.SALVALUE >= JOB.MINSALARY 
    AND SALARY.SALVALUE <= JOB.MINSALARY + 500;
-------------------------------------------------
--ОБЪЕДИНЕНИЕ ТАБЛИЦ: ///////////////////////////
-------------------------------------------------
--ВНУТРЕННЕЕ: ///////////////////////////////////
-------------------------------------------------
--Укажите сведения о заработной плате, совпадающей с минимальными окладами по должностям (с указанием этих должностей).
SELECT SALARY.EMPNO, SALARY.MONTH, SALARY.YEAR, SALARY.SALVALUE, JOB.JOBNAME FROM SALARY JOIN JOB ON SALARY.SALVALUE=JOB.MINSALARY;
-------------------------------------------------
--ЕСТЕСТВЕННОЕ: /////////////////////////////////
-------------------------------------------------
--Найдите сведения о карьере сотрудников с указанием вместо номера сотрудника его имени.
SELECT EMP.EMPNAME, CAREER.JOBNO, CAREER.DEPTNO, CAREER.STARTDATE, CAREER.ENDDATE FROM EMP NATURAL JOIN CAREER; 
-------------------------------------------------
--ПРОСТОЕ ВНУТРЕННЕЕ СОЕДИНЕНИЕ: ////////////////
-------------------------------------------------
--Найдите  сведения о карьере сотрудников с указанием вместо номера сотрудника его имени.
SELECT EMP.EMPNAME, CAREER.JOBNO, CAREER.DEPTNO, CAREER.STARTDATE, CAREER.ENDDATE FROM EMP JOIN CAREER ON EMP.EMPNO = CAREER.EMPNO;
-------------------------------------------------
--ОБЪЕДИНЕНИЕ ТРЁХ И БОЛЬШЕГО ЧИСЛА ТАБЛИЦ: /////
-------------------------------------------------
--Выдайте сведения о карьере сотрудников с указанием их имён, наименования должности, и названия отдела.
SELECT EMP.EMPNAME, JOB.JOBNAME, DEPT.DEPTNAME, CAREER.STARTDATE, CAREER.ENDDATE 
	FROM CAREER 
	JOIN EMP ON EMP.EMPNO = CAREER.EMPNO
	JOIN DEPT ON CAREER.DEPTNO=DEPT.DEPTNO
	JOIN JOB ON CAREER.JOBNO=JOB.JOBNO;
-------------------------------------------------
--ВНЕШНЕЕ ОБЪЕДИНЕНИЕ: //////////////////////////
-------------------------------------------------
--Выдайте сведения о карьере сотрудников с указанием их имён. 
SELECT EMP.EMPNAME, CAREER.STARTDATE, CAREER.ENDDATE
	FROM EMP
	FULL OUTER JOIN CAREER
	ON EMP.EMPNO = CAREER.EMPNO;
