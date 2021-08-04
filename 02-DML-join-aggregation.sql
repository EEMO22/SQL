----------
-- JOIN
----------

-- 먼저 employees와 departments를 확인
DESC employees;
DESC departments;

-- 두 테이블로부터 모든 레코드를 추출: Cartision Product or Cross Join
SELECT first_name, emp.department_id, dept.department_id, department_name
FROM employees emp, departments dept
ORDER BY first_name;

-- 테이블 조인을 위한 조건 부여할 수 있다. Simple JOIN
SELECT first_name, emp.department_id, dept.department_id, department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id; 

-- 총 몇 명의 사원이 있는가?
SELECT COUNT(*) FROM employees; --   107명

SELECT first_name, department_id, department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id;   --  106명

-- department_id가 null인 사원?
SELECT * FROM employees
WHERE department_id IS NULL;

-- USING : 조인할 컬럼을 명시
SELECT first_name, department_name
FROM employees JOIN departments USING(department_id);

-- ON: JOIN의 조건절
SELECT first_name, department_name
FROM employees emp JOIN departments dept
                    ON (emp.department_id = dept.department_id); -- JOIN의 조건
                    
-- Natural JOIN
-- 조건 명시 하지 않고, 같은 이름을 가진 컬럼으로 JOIN
SELECT first_name, department_name
FROM employees NATURAL JOIN departments;
-- 잘못된 쿼리 : Natural Join은 조건을 잘 확인!

-------------
-- OUTER JOIN
-------------

-- 조건이 만족하는 짝이 없는 튜플도 NULL을 포함하여 결과를 출력
-- 모든 레코드를 출력할 테이블의 위치에 따라 LEFT, RIGHT, FULL OUTER JOIN으로 구분
-- ORACLE의 경우 NULL을 출력할 조건 쪽에 (+)를 명시

-- ORACLE SQL
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id (+);

-- ANSI SQL
SELECT emp.first_name,
    emp.department_id,
    dept.department_id,
    dept.department_name
FROM employees emp LEFT OUTER JOIN department dept
                    ON emp.department_id = dept.department_id;
                    
-- RIGHT OUTER JOIN: 짝이 없는 오른쪽 레코드도 NULL을 포함하여 출력
-- ORACLE SQL
SELECT first_name, emp.department_id,
    dept.department_id, dept.department_name
FROM employees emp, departments dept
WHERE emp.department_id (+) = dept.department_id;

-- ANSI SQL
SELECT emp.first_name, emp.department_id,
    dept.department_id, dept.department_name
FROM employees emp RIGHT OUTER JOIN departments dept
                    ON emp.department_id = dept.department_id;
                    
-- FULL OUTER JOIN
-- 양쪽 테이블 레코드 전부를 짝이 없어도 출력에 참여

-- ORACLE SQL (+) 방식으로는 불가
-- SELECT emp.first_name, emp.department_id,
--    dept.department_id, dept.department_name
-- FROM employees emp, departments dept
-- WHERE emp.department_id (+) = dept.department_id (+);


-- ANSI SQL
SELECT emp.first_name, emp.department_id,
    dept.department_id, dept.department_name
FROM employees emp FULL OUTER JOIN departments dept
                    ON emp.department_id = dept.department_id;
                    
------------
-- SELF JOIN
------------

-- 자기 자신과 JOIN
-- 자기 자신을 두 번 이상 호출 -> alias를 사용할 수밖에 없는 JOIN
SELECT * FROM employees;    -- 107명 확인

-- 사원 정보, 매니저 이름을 함께 출력
-- 방법 1.
SELECT emp.employess_id,
    emp.first_name,
    emp.manager_id,
    man.employee_id,
    man.first_name
FROM employees emp JOIN employees man
                    ON emp.manager_id = man.employee_id
ORDER BY emp.employee_id;

-- 방법 2.
SELECT emp.employee_id,
    emp.first_name,
    emp.manager_id,
    man.employee_id,
    man.first_name
FROM employees emp, employees man
WHERE emp.manager_id = man.employee_id (+) -- LEFT OUTER JOIN
ORDER BY emp.employee_id;









