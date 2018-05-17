1-------------------------------
  SELECT empno, salvalue, RANK() OVER(ORDER BY salvalue) rnk, DENSE_RANK() OVER(ORDER BY salvalue) rnk_dense FROM SALARY;
