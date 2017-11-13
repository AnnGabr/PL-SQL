--Предствить имя каждого сотрудника тфблицы EMP и имя его руководителя:
-----------------------------------------------------------------------
SELECT t1.empname || ' works for ' || t2.empname as Emp_Manager
FROM emp t1, emp t2
WHERE t1.manager_id = t2.empno;
 
--Требуется представить имя каждого сотрудника таблицы EMP (даже сотрудника, которому не назначен руководитель) и имя его руководителя.
-----------------------------------------------------------------------
SELECT empname || ' reports to ' || PRIOR empname AS 'Walk top down'  
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR empno = manager_id;
 
-- Требуется показать иерархию от CLARK до JOHN KLINTON:
-- Используйте функцию SYS_CONNECT_BY_PATH получите CLARK и его руководителя ALLEN, затем руководителя ALLEN ― JOHN KLINTON.
-- Для обхода дерева используйте оператор CONNECT BY.
-- А также ключевые слова иерархических запросов LEVEL, START WITH, CONNECT BY PRIOR; функцию LTRIM.
-----------------------------------------------------------------------
SELECT LTRIM(SYS_CONNECT_BY_PATH(EMPNAME,'-->'), '-->') 
FROM EMP
WHERE MANAGER_ID IS NULL
    START WITH EMPNAME = 'CLARK'
    CONNECT BY PRIOR MANAGER_ID = EMPNO;
-- SYS_CONNECT_BY_PATH is valid only in hierarchical queries.
-- It returns the path of a column value from root to node, with column 
-- values separated by char for each row returned by CONNECT BY condition. 
-- В решении для Oracle всю работу выполняет оператор CONNECT BY.
-- Начиная с CLARK, проходим весь путь до JOHN KLIN без всяких объединений. 
-- Выражение в операторе CONNECT BY определяет отношения между данными и то, как будет выполняться обход дерева.

-- 4. Иерархическое представление таблицы
-----------------------------------------------------------------------
SELECT ltrim(sys_connect_by_path(empname,'-->'), '-->') emp_tree
FROM emp
    START WITH manager_id IS NULL
    CONNECT BY PRIOR empno = manager_id
ORDER BY 1;
 
-- 5. Представление уровня иерархии
-- Требуется показать уровень иерархии каждого сотрудника:
-- SHOW LPAD('Page 1',15,'*.')
-- *.*.*.*.*Page 1
-----------------------------------------------------------------------
SELECT lpad(empname,2*(level - 1) + length(empname),'.') emp_tree
    FROM emp
    START WITH manager_id IS NULL  
    CONNECT BY PRIOR empno = manager_id;
 
 
-- 6. Требуется найти всех служащих, которые явно или  неявно подчиняются ALLEN:
-----------------------------------------------------------------------
SELECT empname  
FROM emp
START WITH empname = 'ALLEN'
CONNECT BY PRIOR empno = manager_id ;
