------------------------------1--------------------------— 
SELECT E.EMPNAME || ' works for ' || M.EMPNAME AS Emp_Manager 
FROM EMP E 
INNER JOIN EMP M 
ON E.MANAGER_ID = M.EMPNO; 

-------------------------------2--------------------------— 
SELECT EMPNAME || ' reports to ' || PRIOR EMPNAME AS "Walk Top Down" 
FROM EMP 
START WITH MANAGER_ID IS NULL 
CONNECT BY PRIOR EMPNO = MANAGER_ID; 

-------------------------------3-------------------------— 
SELECT LTRIM(SYS_CONNECT_BY_PATH (EMPNAME, '->'), '->') AS LEAF__BRANCH__ROOT 
FROM EMP 
WHERE MANAGER_ID IS NULL 
START WITH EMPNAME = 'CLARK' 
CONNECT BY PRIOR MANAGER_ID = EMPNO; 

-------------------------------4---------------------------— 
SELECT LTRIM(SYS_CONNECT_BY_PATH (EMPNAME, '->'), '->') AS EMP_Tree 
FROM EMP 
START WITH MANAGER_ID IS NULL 
CONNECT BY PRIOR EMPNO = MANAGER_ID; 

--------------------------------5--------------------------— 
SELECT LPAD(' ', LEVEL, '*') || EMPNAME AS Org_Chart 
FROM EMP 
START WITH MANAGER_ID IS NULL 
CONNECT BY PRIOR EMPNO = MANAGER_ID; 

-------------------------------6---------------------------— 
SELECT EMPNAME 
FROM EMP 
START WITH EMPNAME = 'ALLEN' 
CONNECT BY PRIOR EMPNO = MANAGER_ID;
