--ВЛОЖЕННЫЕ ПОДЗАПРОСЫ:
------------------------------------------------------
--ПОДЗАПРОСЫ, ВЫБИРАЮЩИЕ ОДНУ СТРОКУ
------------------------------------------------------
--1.	Найти имена сотрудников, получивших за годы начисления зарплаты минимальную зарплату.
SELECT EMP.EMPNAME, SALARY.SALVALUE FROM EMP NATURAL 
      JOIN SALARY WHERE SALARY.SALVALUE IN( SELECT MIN(SALARY.SALVALUE) FROM SALARY )
------------------------------------------------------
--ПОДЗАПРОСЫ, ВОЗВРАЩАЮЩИЕ БОЛЕЕ ОДНОЙ СТРОКИ
------------------------------------------------------
--2.	Найти имена сотрудников, работавших или работающих в тех же отделах, в которых работал или работает сотрудник с именем RICHARD MARTIN.

СРАВНЕНИЕ БОЛЕЕ ЧЕМ ПО ОДНОМУ ЗНАЧЕНИЮ

3.	Найти имена сотрудников, работавших или работающих в тех же отделах и должностях, что и сотрудник 'RICHARD MARTIN'.

ОПЕРАТОРЫ ANY/ALL

4.    Найти сведения о номерах сотрудников, получивших за какой-либо месяц зарплату большую, чем средняя зарплата   за 2007 г. или большую чем средняя зарплата за 2008г.

5.    Найти сведения о номерах сотрудников, получивших зарплату за какой-либо месяц большую, чем средние зарплаты за все годы начислений.


ИСПОЛЬЗОВАНИЕ HAVING С ВЛОЖЕННЫМИ ПОДЗАПРОСАМИ

6.	Определить годы, в которые начисленная средняя зарплата была больше средней зарплаты за все годы начислений.

КОРРЕЛИРУЮЩИЕ ПОДЗАПРОСЫ

7.    Определить номера отделов, в которых работали или работают сотрудники, имеющие начисления зарплаты. 

ОПЕРАТОР EXISTS

8.	Определить номера отделов, в которых работали или работают сотрудники, имеющие начисления зарплаты.

      ОПЕРАТОР NOT EXISTS

9.	Определить номера отделов, для сотрудников которых не начислялась зарплата.


СОСТАВНЫЕ ЗАПРОСЫ

10.	Вывести сведения о карьере сотрудников с указанием названий и адресов отделов вместо номеров отделов.


       ОПЕРАТОР CAST

11.	Определить целую часть средних зарплат,  по годам начисления.

ОПЕРАТОР CASE

12.   Разделите сотрудников на возрастные группы: A) возраст 20-30 лет; B) 31-40 лет; C) 41-50;    D) 51-60 или возраст не определён.

13.	Перекодируйте номера отделов, добавив перед номером отдела буквы BI для номеров <=20,  буквы  LN для номеров >=30.


ОПЕРАТОР COALESCE (объединяться)

14.	Выдать информацию о сотрудниках из таблицы EMP, заменив отсутствие данного о дате рождения  датой '01-01-1000'.
