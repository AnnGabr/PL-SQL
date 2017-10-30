--ВЛОЖЕННЫЕ ПОДЗАПРОСЫ:
------------------------------------------------------
--ПОДЗАПРОСЫ, ВЫБИРАЮЩИЕ ОДНУ СТРОКУ
------------------------------------------------------
--1.  Найти имена сотрудников, получивших за годы начисления зарплаты минимальную зарплату.
SELECT EMP.EMPNAME, SALARY.SALVALUE FROM EMP NATURAL 
      JOIN SALARY WHERE SALARY.SALVALUE = (SELECT MIN(SALARY.SALVALUE) FROM SALARY);
------------------------------------------------------
--ПОДЗАПРОСЫ, ВОЗВРАЩАЮЩИЕ БОЛЕЕ ОДНОЙ СТРОКИ
------------------------------------------------------
--2.  Найти имена сотрудников, работавших или работающих в тех же отделах, в которых работал или работает сотрудник с именем RICHARD MARTIN.
SELECT EMP.EMPNAME FROM EMP JOIN CAREER USING (EMPNO) 
      WHERE CAREER.DEPTNO 
            IN( SELECT CAREER.DEPTNO FROM EMP JOIN CAREER USING (EMPNO) WHERE LOWER(EMP.EMPNAME)='richard martin' GROUP BY CAREER.DEPTNO) 
      GROUP BY EMP.EMPNAME;
------------------------------------------------------      
--СРАВНЕНИЕ БОЛЕЕ ЧЕМ ПО ОДНОМУ ЗНАЧЕНИЮ
------------------------------------------------------
--3.	Найти имена сотрудников, работавших или работающих в тех же отделах и должностях, что и сотрудник 'RICHARD MARTIN'.
SELECT EMP.EMPNAME FROM EMP JOIN CAREER USING (EMPNO) 
      WHERE (CAREER.DEPTNO, CAREER.JOBNO)
            IN( SELECT CAREER.DEPTNO, CAREER.JOBNO FROM EMP JOIN CAREER USING (EMPNO) WHERE LOWER(EMP.EMPNAME)='richard martin' ) 
      GROUP BY EMP.EMPNAME;
------------------------------------------------------
--ОПЕРАТОРЫ ANY/ALL
------------------------------------------------------
--4.  Найти сведения о номерах сотрудников, получивших за какой-либо месяц зарплату большую, чем средняя зарплата   за 2007 г. или большую чем средняя зарплата за 2008г.
SELECT EMPNO FROM EMP 
      JOIN SALARY USING (EMPNO) 
      WHERE SALARY.SALVALUE > ANY( (SELECT AVG(SALARY.SALVALUE) FROM SALARY WHERE SALARY.YEAR=2007 ), (SELECT AVG(SALARY.SALVALUE) FROM SALARY WHERE SALARY.YEAR=2008 ) )
      GROUP BY EMPNO;
--5.  Найти сведения о номерах сотрудников, получивших зарплату за какой-либо месяц большую, чем средние зарплаты за все годы начислений.
SELECT EMPNO FROM SALARY 
      WHERE SALARY.SALVALUE > ALL (SELECT AVG(SALARY.SALVALUE) FROM SALARY GROUP BY YEAR)
      GROUP BY EMPNO;
------------------------------------------------------
--ИСПОЛЬЗОВАНИЕ HAVING С ВЛОЖЕННЫМИ ПОДЗАПРОСАМИ
------------------------------------------------------
--6.	Определить годы, в которые начисленная средняя зарплата была больше средней зарплаты за все годы начислений.
SELECT YEAR FROM SALARY 
      GROUP BY YEAR 
      HAVING AVG(SALVALUE) > (SELECT AVG(SALARY.SALVALUE) FROM SALARY);
------------------------------------------------------
--КОРРЕЛИРУЮЩИЕ ПОДЗАПРОСЫ
------------------------------------------------------
--7.  Определить номера отделов, в которых работали или работают сотрудники, имеющие начисления зарплаты.
SELECT DISTINCT DEPTNO
      FROM CAREER
      WHERE (SELECT COUNT(*)
                  FROM SALARY
                  WHERE SALARY.EMPNO = CAREER.EMPNO ) > 0
            AND DEPTNO IS NOT NULL;
------------------------------------------------------
--ОПЕРАТОР EXISTS
------------------------------------------------------
--8.	Определить номера отделов, в которых работали или работают сотрудники, имеющие начисления зарплаты.
 SELECT DEPTNO FROM DEPT WHERE EXISTS ( SELECT * FROM CAREER JOIN SALARY USING(EMPNO) WHERE CAREER.DEPTNO=DEPT.DEPTNO);
------------------------------------------------------
--ОПЕРАТОР NOT EXISTS
------------------------------------------------------
--9.	Определить номера отделов, для сотрудников которых не начислялась зарплата.
 SELECT DEPTNO FROM DEPT WHERE NOT EXISTS ( SELECT * FROM CAREER JOIN SALARY USING(EMPNO) WHERE CAREER.DEPTNO=DEPT.DEPTNO);
------------------------------------------------------
--СОСТАВНЫЕ ЗАПРОСЫ
------------------------------------------------------
--10.	Вывести сведения о карьере сотрудников с указанием названий и адресов отделов вместо номеров отделов.
SELECT CAREER.EMPNO, DEPT.DEPTNAME, DEPT.DEPTADDR FROM CAREER LEFT JOIN DEPT USING(DEPTNO);
------------------------------------------------------
--ОПЕРАТОР CAST
------------------------------------------------------
--11.	Определить целую часть средних зарплат,  по годам начисления.
SELECT CAST(AVG(SALARY.SALVALUE) AS INTEGER) FROM SALARY GROUP BY YEAR;
SELECT TRUNC(AVG(SALARY.SALVALUE)) FROM SALARY GROUP BY YEAR;
------------------------------------------------------
--ОПЕРАТОР CASE
------------------------------------------------------
--12. Разделите сотрудников на возрастные группы: A) возраст 20-30 лет; B) 31-40 лет; C) 41-50; D) 51-60 или возраст не определён.
      
--13.	Перекодируйте номера отделов, добавив перед номером отдела буквы BI для номеров <=20,  буквы  LN для номеров >=30.
SELECT 
      CASE 
            WHEN DEPTNO <= 20 THEN 'BI' || DEPTNO
            WHEN DEPTNO >= 30 THEN 'LN' || DEPTNO
            ELSE TO_CHAR(DEPTNO)
      END
FROM DEPT;
------------------------------------------------------
--ОПЕРАТОР COALESCE (объединяться)
------------------------------------------------------
--14.	Выдать информацию о сотрудниках из таблицы EMP, заменив отсутствие данного о дате рождения  датой '01-01-1000'.
SELECT EMPNAME, COALESCE(BIRTHDATE, to_date('01-01-1000', 'dd-mm-yyyy')) FROM EMP
