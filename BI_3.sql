1-------------------------------
  SELECT empno, salvalue, RANK() OVER(ORDER BY salvalue) rnk, DENSE_RANK() OVER(ORDER BY salvalue) rnk_dense FROM SALARY;

2-------------------------------
  SELECT career.jobno, salary.salvalue, RATIO_TO_REPORT(salary.salvalue) OVER (PARTITION BY career.jobno) ratio 
    FROM career INNER JOIN salary on career.empno = salary.empno 
      WHERE career.enddate IS NULL 
      ORDER BY ratio DESC;
