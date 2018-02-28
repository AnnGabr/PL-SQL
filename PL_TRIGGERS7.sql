
-- 01. Добавьте в таблицу SALARY столбец TAX (налог) для вычисления ежемесячного подоходного
--     налога на зарплату по прогрессивной шкале. Налог вычисляется по следующему правилу:
--     * налог равен 9% от начисленной  в месяце зарплаты, если суммарная зарплата с начала года до
--       конца рассматриваемого месяца не превышает 20 000;
--     * налог равен 12% от начисленной  в месяце зарплаты, если суммарная зарплата с начала года
--       до конца рассматриваемого месяца больше 20 000, но не превышает 30 000;
--     * налог равен 15% от начисленной  в месяце зарплаты, если суммарная зарплата с начала года
--       до конца рассматриваемого месяца  больше 30 000.

ALTER TABLE SALARY ADD (TAX NUMBER(15))

-- 02. 2. Составьте программу вычисления налога и вставки её в таблицу SALARY:
-- a) с помощью простого цикла (loop) с курсором и оператора if;
CREATE OR REPLACE PROCEDURE tax_loop_if AS
    sal_sum NUMBER;
    CURSOR CUR IS SELECT * FROM salary FOR UPDATE OF TAX;
    rec CUR%ROWTYPE;
BEGIN
    OPEN CUR;
    LOOP
        FETCH CUR INTO rec;
        EXIT WHEN CUR%NOTFOUND;
        
        SELECT SUM(SALVALUE) INTO sal_sum FROM salary
            WHERE EMPNO = rec.EMPNO AND MONTH < rec.MONTH AND YEAR = rec.YEAR;

        IF sal_sum < 20000 THEN
            UPDATE salary SET TAX = rec.SALVALUE * 0.09
                WHERE EMPNO = rec.EMPNO AND MONTH = rec.MONTH AND YEAR = rec.YEAR;
        ELSIF sal_sun < 30000 THEN
            UPDATE salary SET TAX = rec.SALVALUE * 0.12
                WHERE EMPNO = rec.EMPNO AND MONTH = rec.MONTH AND YEAR = rec.YEAR;
        ELSE
            UPDATE salary SET TAX = rec.SALVALUE * 0.15
                WHERE EMPNO = rec.EMPNO AND MONTH = rec.MONTH AND YEAR = rec.YEAR;
        END IF;
    END LOOP;
    CLOSE CUR;
END tax_loop_if;
/

-- b) с помощью простого цикла (loop) с курсором и оператора case;
CREATE OR REPLACE PROCEDURE tax_loop_case AS
    sal_sum NUMBER;
    CURSOR CUR IS SELECT * FROM salary FOR UPDATE OF TAX;
    rec CUR%ROWTYPE;
BEGIN
    OPEN CUR;
    LOOP
        FETCH CUR INTO rec;
        EXIT WHEN CUR%NOTFOUND;
        
        SELECT SUM(SALVALUE) INTO sal_sum FROM salary
            WHERE EMPNO = rec.EMPNO AND MONTH < rec.MONTH AND YEAR = rec.YEAR;

        UPDATE salary SET TAX =
            CASE
                WHEN sal_sum < 20000 THEN rec.SALVALUE * 0.09
                WHEN sal_sum < 30000 THEN rec.SALVALUE * 0.12
                ELSE rec.SALVALUE * 0.15
            END
            WHERE EMPNO = rec.EMPNO AND MONTH = rec.MONTH AND YEAR = rec.YEAR;
    END LOOP;
    CLOSE CUR;
END tax_loop_case;
/

-- c) с помощью курсорного цикла FOR;
CREATE OR REPLACE PROCEDURE tax_cur_for AS
    sal_sum NUMBER;
    CURSOR CUR IS SELECT * FROM salary FOR UPDATE OF TAX;
BEGIN
   FOR rec IN CUR 
   LOOP
        SELECT SUM(SALVALUE) INTO sel_sum FROM salary
             WHERE EMPNO = rec.EMPNO AND MONTH < rec.MONTH AND YEAR = rec.YEAR;

        UPDATE salary SET TAX =
            CASE
                WHEN sal_sum < 20000 THEN rec.SALVALUE * 0.09
                WHEN sal_sum < 30000 THEN rec.SALVALUE * 0.12
                ELSE rec.SALVALUE * 0.15
            END
            WHERE EMPNO = rec.EMPNO AND MONTH = rec.MONTH AND YEAR = rec.YEAR;
    END LOOP;
    CLOSE CUR;
END tax_cur_for;
/

-- d) с помощью курсора с параметром, передавая номер сотрудника, для которого необходимо посчитать
--    налог.
CREATE  OR  REPLACE  PROCEDURE  tax_param (EMPID  PLS_INTEGER)  AS
    CURSOR CUR IS SELECT * FROM salary WHERE EMPNO = EMPID FOR UPDATE OF TAX;
    sal_sum NUMBER;
BEGIN
    FOR rec IN CUR 
    LOOP
        SELECT SUM(SALVALUE) INTO sel_sum FROM salary
             WHERE EMPNO = rec.EMPNO AND MONTH < rec.MONTH AND YEAR = rec.YEAR;

        UPDATE salary SET TAX =
            CASE
                WHEN sal_sum < 20000 THEN rec.SALVALUE * 0.09
                WHEN sal_sum < 30000 THEN rec.SALVALUE * 0.12
                ELSE rec.SALVALUE * 0.15
            END
            WHERE EMPNO = rec.EMPNO AND MONTH = rec.MONTH AND YEAR = rec.YEAR;
    END LOOP;
    CLOSE CUR;
END  tax_param;
/

-- 04. Создайте процедуру, вычисляющую налог на зарплату за всё время начислений для конкретного
--     сотрудника. В качестве параметров передать процент налога (до 20000, до 30000, выше 30000,
--     номер сотрудника).
CREATE  OR  REPLACE  PROCEDURE  tax_proc_empno (
    EMPID PLS_INTEGER, 
    less20 NUMBER,
    more20 NUMBER,
    more30 NUMBER)  AS
    CURSOR CUR IS SELECT * FROM salary WHERE EMPNO = EMPID FOR UPDATE OF TAX;
    sal_sum NUMBER;
BEGIN
    FOR rec IN CUR 
    LOOP
        SELECT SUM(SALVALUE) INTO sel_sum FROM salary
             WHERE EMPNO = rec.EMPNO AND MONTH < rec.MONTH AND YEAR = rec.YEAR;

        UPDATE salary SET TAX =
            CASE
                WHEN sal_sum < 20000 THEN rec.SALVALUE * less20
                WHEN sal_sum < 30000 THEN rec.SALVALUE * more20
                ELSE rec.SALVALUE * more30
            END
    END LOOP;
    CLOSE CUR;
END  tax_proc_empno;
/

-- 05.  Создайте функцию, вычисляющую суммарный налог на зарплату сотрудника за всё время начислений.
--      В качестве параметров передать процент налога (до 20000, до 30000, выше 30000, номер
--      сотрудника). Возвращаемое значение – суммарный налог.
CREATE  OR  REPLACE  FUNCTION  tax_emp_gen (
    EMPID PLS_INTEGER, 
    less20 NUMBER,
    more20 NUMBER,
    more30 NUMBER)  AS
    CURSOR CUR IS SELECT * FROM salary WHERE EMPNO = EMPID FOR UPDATE OF TAX;
    sal_sum NUMBER;
    result NUMBER;
BEGIN
    result := 0;
    FOR rec IN CUR 
    LOOP
        SELECT SUM(SALVALUE) INTO sel_sum FROM salary
             WHERE EMPNO = rec.EMPNO AND MONTH < rec.MONTH AND YEAR = rec.YEAR;

        result := result +
            CASE
                WHEN sal_sum < 20000 THEN rec.SALVALUE * less20
                WHEN sal_sum < 30000 THEN rec.SALVALUE * more20
                ELSE rec.SALVALUE * more30
            END;
    END LOOP;
    CLOSE CUR;
    RETURN result;
END  tax_emp_gen;
/

-- Вызов
SELECT tax_emp_gen(EMPNO, 1, 2, 3) FROM salary

-- 06.  Создайте пакет, включающий в свой состав процедуру вычисления налога для всех сотрудников,
--      процедуру вычисления налогов для отдельного сотрудника, идентифицируемого своим номером,
--      функцию вычисления суммарного налога на зарплату сотрудника за всё время начислений.
CREATE OR REPLACE PACKAGE tax_package AS
    PROCEDURE  tax_loop_if();
    PROCEDURE  tax_param(EMPID  NUMBER);
    FUNCTION  tax_emp_gen(
    EMPID PLS_INTEGER,
    less20 NUMBER,
    more20 NUMBER,
    more30 NUMBER);
END tax_package;
/

CREATE OR REPLACE PACKAGE BODY tax_package AS
    PROCEDURE tax_loop_if AS
        sal_sum NUMBER;
        CURSOR CUR IS SELECT * FROM salary FOR UPDATE OF TAX;
        rec CUR%ROWTYPE;
    BEGIN
        OPEN CUR;
        LOOP
            FETCH CUR INTO rec;
            EXIT WHEN CUR%NOTFOUND;

            SELECT SUM(SALVALUE) INTO sal_sum FROM salary
                WHERE EMPNO = rec.EMPNO AND MONTH < rec.MONTH AND YEAR = rec.YEAR;

            IF sal_sum < 20000 THEN
                UPDATE salary SET TAX = rec.SALVALUE * 0.09
                    WHERE EMPNO = rec.EMPNO AND MONTH = rec.MONTH AND YEAR = rec.YEAR;
            ELSIF sal_sun < 30000 THEN
                UPDATE salary SET TAX = rec.SALVALUE * 0.12
                    WHERE EMPNO = rec.EMPNO AND MONTH = rec.MONTH AND YEAR = rec.YEAR;
            ELSE
                UPDATE salary SET TAX = rec.SALVALUE * 0.15
                    WHERE EMPNO = rec.EMPNO AND MONTH = rec.MONTH AND YEAR = rec.YEAR;
            END IF;
        END LOOP;
        CLOSE CUR;
    END tax_loop_if;

    PROCEDURE  tax_param (EMPID  PLS_INTEGER)  AS
        CURSOR CUR IS SELECT * FROM salary WHERE EMPNO = EMPID FOR UPDATE OF TAX;
        sal_sum NUMBER;
    BEGIN
        FOR rec IN CUR 
        LOOP
            SELECT SUM(SALVALUE) INTO sel_sum FROM salary
                 WHERE EMPNO = rec.EMPNO AND MONTH < rec.MONTH AND YEAR = rec.YEAR;

            UPDATE salary SET TAX =
                CASE
                    WHEN sal_sum < 20000 THEN rec.SALVALUE * 0.09
                    WHEN sal_sum < 30000 THEN rec.SALVALUE * 0.12
                    ELSE rec.SALVALUE * 0.15
                END
                WHERE EMPNO = rec.EMPNO AND MONTH = rec.MONTH AND YEAR = rec.YEAR;
        END LOOP;
        CLOSE CUR;
    END  tax_param;

    FUNCTION  tax_emp_gen (
        EMPID PLS_INTEGER, 
        less20 NUMBER,
        more20 NUMBER,
        more30 NUMBER)  AS
        CURSOR CUR IS SELECT * FROM salary WHERE EMPNO = EMPID FOR UPDATE OF TAX;
        sal_sum NUMBER;
        result NUMBER;
    BEGIN
        result := 0;
        FOR rec IN CUR 
        LOOP
            SELECT SUM(SALVALUE) INTO sel_sum FROM salary
                 WHERE EMPNO = rec.EMPNO AND MONTH < rec.MONTH AND YEAR = rec.YEAR;

            result := result +
                CASE
                    WHEN sal_sum < 20000 THEN rec.SALVALUE * less20
                    WHEN sal_sum < 30000 THEN rec.SALVALUE * more20
                    ELSE rec.SALVALUE * more30
                END;
        END LOOP;
        CLOSE CUR;
        RETURN result;
    END  tax_emp_gen;
END tax_package;
/

-- 07.  Создайте триггер, действующий при обновлении данных в таблице SALARY. А именно, если
--      происходит обновление поля SALVALUE, то при назначении новой зарплаты, меньшей чем
--      должностной оклад (таблица JOB, поле MINSALARY), изменение не вносится  и сохраняется старое
--      значение, если новое значение зарплаты больше должностного оклада, то изменение вносится.
CREATE OR REPLACE TRIGGER new_salary
    BEFORE UPDATE OF SALVALUE ON salary FOR EACH ROW
DECLARE
    CUR(EMPID CAREER.EMPNO%TYPE) IS
        SELECT MINSALARY FROM JOB
            WHERE JOBNO = (SELECT JOBNO FROM CAREER WHERE EMPID = EMPNO AND ENDDATE IS NULL);
    rec JOB.MINSALARY%TYPE;
BEGIN
    OPEN CUR(:NEW.EMPNO);
    FETCH CUR INTO rec;
    IF :NEW.SALVALUE < rec THEN
        :NEW.SALVALUE := :OLD.SALVALUE;
    END IF;
    CLOSE CUR;
END new_salary;
/

-- 08. Создайте триггер, действующий при удалении записи из таблицы CAREER. Если в удаляемой строке
--     поле ENDDATE содержит NULL, то запись не удаляется, в противном случае удаляется.

CREATE OR REPLACE TRIGGER delete_career_rec
    BEFORE DELETE ON CAREER
    FOR EACH ROW
BEGIN
    IF :OLD.ENDDATE IS NULL THEN
        RAISE_APPLICATION_ERROR (–20212, 'Can`t delete recod with NULL in ENDDATE.');
    END IF;
END delete_career_rec;
/

-- 09. Создайте триггер, действующий на добавление или изменение данных в таблице EMP.
--     Если во вставляемой или изменяемой строке поле BIRTHDATE содержит NULL, то после вставки или
--     изменения должно быть выдано сообщение ‘BERTHDATE is NULL’. Если во вставляемой или изменяемой
--     строке поле BIRTHDATE содержит дату ранее ‘01-01-1940’, то должно быть выдано сообщение
--     ‘PENTIONA’. Во вновь вставляемой строке имя служащего должно быть приведено к заглавным букваь.
CREATE OR REPLACE TRIGGER ON_EMP_INSERT_UPDATE
    BEFORE INSERT OR UPDATE ON EMP
    FOR EACH ROW
BEGIN
    IF :NEW.BIRTHDATE IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('BIRTHDATE IS NULL');
    END IF;

    IF :NEW.BIRTHDATE < to_date('01-01-1940', 'dd-mm-yyyy') THEN
        DBMS_OUTPUT.PUT_LINE('PENTIONA');
    END IF;

    :NEW.EMPNAME := UPPER(:NEW.EMPNAME);
END ON_EMP_INSERT_UPDATE;

--10.  Создайте программу изменения типа заданной переменной из символьного типа (VARCHAR2) в
--     числовой тип (NUMBER).
--     Программа должна содержать раздел обработки исключений. Обработка должна заключаться в выдаче
--     сообщения ‘ERROR: argument is not a number’ .  Исключительная ситуация возникает при задании
--     строки в виде числа с запятой, разделяющей дробную и целую части.
DECLARE
    X number;
    FUNCTION str2nr(str in varchar2) return NUMBER  IS
    BEGIN
        RETURN CAST(str AS NUMBER);
        EXCEPTION
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('CLASS CAST EXCEPTION ' || str);
            RETURN NULL;
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20103, 'SHOULD NOT GET THERE');
        RETURN NULL;
    END;
BEGIN
    x := str2nr( '1234123' );
    DBMS_OUTPUT.PUT_LINE(x);
    x := str2nr( '5.1' );
    DBMS_OUTPUT.PUT_LINE(x);
    x := str2nr( '4,123' );
    DBMS_OUTPUT.PUT_LINE(x);
END;
