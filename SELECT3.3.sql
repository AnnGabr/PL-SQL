-- Предствить имя каждого сотрудника тфблицы EMP и имя его руководителя:
-----------------------------------------------------------------------
SELECT t1.empname || ' works for ' || t2.empname as Emp_Manager
     FROM emp t1, emp t2
     WHERE t1.manager_id = t2.empno;
 
-- Требуется представить имя каждого сотрудника таблицы EMP (даже сотрудника, которому не назначен руководитель) и имя его руководителя:
-----------------------------------------------------------------------
SELECT empname || ' reports to ' || PRIOR empname AS 'Walk top down'  
     START WITH MANAGER_ID IS NULL
     CONNECT BY PRIOR empno = manager_id;
 
-- Требуется показать иерархию от CLARK до JOHN KLINTON:
-----------------------------------------------------------------------
SELECT LTRIM(SYS_CONNECT_BY_PATH(EMPNAME,'-->'), '-->') leaf_branch_root
FROM EMP
WHERE level = 3
    START WITH EMPNAME = 'CLARK'
    CONNECT BY PRIOR MANAGER_ID = EMPNO;

-- Иерархическое представление таблицы(сортировка по первому столбцу):
-----------------------------------------------------------------------
SELECT ltrim(sys_connect_by_path(empname,'-->'), '-->') emp_tree
FROM emp
    START WITH manager_id IS NULL
    CONNECT BY PRIOR empno = manager_id
ORDER BY 1;
 
-- 5. Требуется показать уровень иерархии каждого сотрудника:
-----------------------------------------------------------------------
SELECT lpad(' ',level,'*') || empname as emp_tree
    FROM emp
    START WITH manager_id IS NULL  
    CONNECT BY PRIOR empno = manager_id; 
 
-- 6. Требуется найти всех служащих, которые явно или  неявно подчиняются ALLEN:
-----------------------------------------------------------------------
SELECT empname  
    FROM emp
    START WITH empname = 'ALLEN'
    CONNECT BY PRIOR empno = manager_id ;

