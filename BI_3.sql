1-------------------------------
  SELECT empno, salvalue, RANK() OVER(ORDER BY salvalue) rnk, DENSE_RANK() OVER(ORDER BY salvalue) rnk_dense FROM SALARY;

2-------------------------------
  SELECT career.jobno, salary.salvalue, RATIO_TO_REPORT(salary.salvalue) OVER (PARTITION BY career.jobno) ratio 
    FROM career INNER JOIN salary on career.empno = salary.empno 
      WHERE career.enddate IS NULL 
      ORDER BY ratio DESC;

3-------------------------------
SELECT salvalue, year, empno, 
  cume_dist() OVER (PARTITION BY year ORDER BY salvalue) cume_dist, 
  percent_rank() OVER (PARTITION BY year ORDER BY salvalue) persent_rank 
  FROM salary;
