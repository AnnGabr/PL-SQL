-------------------------------------------------
--���������� �������: /////////////////////////////
-------------------------------------------------
--������ ���������� � �������������� ������ ������ (SALES) ��������.
	SELECT DEPTADDR FROM DEPT WHERE LOWER(DEPTNAME) = 'sales';
--������ ���������� �� �������, ������������� � Chicago � New York.
	SELECT * FROM DEPT WHERE LOWER(DEPTADDR) IN ('new york', 'chicago');
-------------------------------------------------
--�������: ////////////////////////////////////////
-------------------------------------------------
--����� ����������� ���������� �����, ����������� � 2009 ����.
	SELECT MIN(SALVALUE) FROM SALARY WHERE YEAR = 2009;
--������ ���������� ��� ���� ����������, ���������� �� ������� 1 ������ 1960 ����.
	SELECT * FROM EMP WHERE BIRTHDATE <= to_date('01.01.1960','dd.mm.yyyy');
--���������� ����� ����������, �������� � ������� ������� � ���� ������ .
	SELECT COUNT(*) FROM EMP;
--����� ����������, ��� ��� ������� �� ������ �����. ����� ������ �� ������ ��������, � ��������� ������� ������ ����� t.
	SELECT REGEXP_REPLACE(LOWER(EMPNAME), 't$') NAME FROM EMP WHERE EMPNAME NOT LIKE('% %');
--������ ���������� � ����������, ������ ���� �������� � ������� ����(�����), �����(��������), ���(��������). 
	SELECT EMPNO, TO_CHAR( BIRTHDATE, 'dd-MONTH-YEAR') BIRTHDATE, EMPNAME, MANAGER_ID FROM EMP;
--����, �� ��� ������.
	SELECT EMPNO, TO_CHAR( BIRTHDATE, 'dd-MONTH-yyyy') BIRTHDATE, EMPNAME, MANAGER_ID FROM EMP;
--������ ���������� � ����������, ������� �������� ��������� �CLERK� � �DRIVER� �� �WORKER�.
	SELECT JOBNO, REGEXP_REPLACE(JOBNAME, 'CLERK|DRIVER', 'WORKER') NEWJOBNAME, MINSALARY FROM JOB;
-------------------------------------------------
--HAVING: /////////////////////////////////////////
-------------------------------------------------
--���������� ������� �������� �� ����, � ������� ���� ���������� �� ����� ��� �� ��� ������.
	SELECT YEAR, AVG(SALVALUE) AVG_SALEVALUE FROM SALARY GROUP BY YEAR HAVING COUNT(MONTH) > 2;
-------------------------------------------------
--���������� �� ���������: ////////////////////////
-------------------------------------------------
--�������� ��������� ��������� �������� � ��������� ���� ��������.
	SELECT EMP.EMPNAME, SALARY.SALVALUE, SALARY.MONTH, SALARY.YEAR FROM EMP, SALARY WHERE EMP.EMPNO=SALARY.EMPNO; 	
-------------------------------------------------
--���������� �� �� ���������: /////////////////////
-------------------------------------------------
--�������  �������� � ���������� ����������� ��������, ���������� � �����: ����������� ����� �� ��������� - ����������� ����� �� ��������� ���� �������. ������� ��������������� �����  ���������.
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
--����������� ������: /////////////////////////////
-------------------------------------------------
--����������: /////////////////////////////////////
-------------------------------------------------
--������� �������� � ���������� �����, ����������� � ������������ �������� �� ���������� (� ��������� ���� ����������).
	SELECT SALARY.EMPNO, SALARY.MONTH, SALARY.YEAR, SALARY.SALVALUE, JOB.JOBNAME FROM SALARY JOIN JOB ON SALARY.SALVALUE=JOB.MINSALARY;
-------------------------------------------------
--������������: ///////////////////////////////////
-------------------------------------------------
--������� �������� � ������� ����������� � ��������� ������ ������ ���������� ��� �����.
	SELECT EMP.EMPNAME, CAREER.JOBNO, CAREER.DEPTNO, CAREER.STARTDATE, CAREER.ENDDATE FROM EMP NATURAL JOIN CAREER; 
-------------------------------------------------
--������� ���������� ����������: //////////////////
-------------------------------------------------
--�������  �������� � ������� ����������� � ��������� ������ ������ ���������� ��� �����.
	SELECT EMP.EMPNAME, CAREER.JOBNO, CAREER.DEPTNO, CAREER.STARTDATE, CAREER.ENDDATE FROM EMP JOIN CAREER ON EMP.EMPNO = CAREER.EMPNO;
-------------------------------------------------
--����������� �Ш� � �������� ����� ������: ///////
-------------------------------------------------
--������� �������� � ������� ����������� � ��������� �� ���, ������������ ���������, � �������� ������.
	SELECT EMP.EMPNAME, JOB.JOBNAME, DEPT.DEPTNAME, CAREER.STARTDATE, CAREER.ENDDATE 
		FROM CAREER 
		JOIN EMP ON EMP.EMPNO = CAREER.EMPNO
		JOIN DEPT ON CAREER.DEPTNO=DEPT.DEPTNO
		JOIN JOB ON CAREER.JOBNO=JOB.JOBNO;
-------------------------------------------------
--������� �����������: ////////////////////////////
-------------------------------------------------
--������� �������� � ������� ����������� � ��������� �� ���. 
	SELECT EMP.EMPNAME, CAREER.STARTDATE, CAREER.ENDDATE
    		FROM EMP
        	FULL OUTER JOIN CAREER
            	ON EMP.EMPNO = CAREER.EMPNO;
