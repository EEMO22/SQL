----------
-- SUBQUERY
----------
-- 하나의 질의문 안에 다른 질의문을 포함하는 형태

-- 전체 사원 중, 급여의 중앙값보다 많이 받는 사원

-- 1. 급여의 중앙값?
SELECT MEDIAN(salary) FROM employees;   --  6200
-- 2. 6200보다 많이 받는 사원 쿼리
SELECT first_name, salary FROM employees WHERE salary > 6200;

-- 3. 두 쿼리를 합친다.
SELECT first_name, salary FROM employees
WHERE salary > (SELECT MEDIAN(salary) FROM employees);

-- Den 보다 늦게 입사한 사원들
-- 1. Den 입사일 쿼리
SELECT hire_date FROM employees WHERE first_name = 'Den'; -- 02/12/07
-- 2. 특정 날짜 이후 입사한 사원 쿼리
SELECT first_name, hire_date FROM employees WHERE hire_date >= '02/12/07';
-- 3. 두 쿼리를 합친다.
SELECT first_name, hire_date 
FROM employees 
WHERE hire_date >= (SELECT hire_date FROM employees WHERE first_name = 'Den');

-- 다중행 서브 쿼리
-- 서브 쿼리의 결과 레코드가 둘 이상이 나올 때는 단일행 연산자를 사용할 수 없다
-- IN, ANY, ALL, EXISTS 등 집합 연산자를 활용
SELECT salary FROM employees WHERE department_id = 110; -- 2 ROW

SELECT first_name, salary FROM employees
WHERE salary = (SELECT salary FROM employees WHERE department_id = 110); -- ERROR

-- 결과가 다중행이면 집합 연산자를 활용
-- salary = 120008 OR salary = 8300
SELECT first_name, salary FROM employees
WHERE salary IN (SELECT salary FROM employees WHERE department_id = 110);

-- ALL(AND)
-- salary > 12008 AND salary > 8300
SELECT first_name, salary FROM employees
WHERE salary > ALL (SELECT salary FROM employees WHERE department_id = 110);

-- ANY(OR)
SELECT first_name, salary FROM employees
WHERE salary > ANY (SELECT salary FROM employees WHERE department_id = 110);

-- Correlated Query
-- 외부 쿼리와 내부 쿼리가 연관관계를 맺는 쿼리
SELECT e.department_id, e.employee_id, e.first_name, e.salary
FROM employees e
WHERE e.salary = (SELECT MAX(salary) FROM employees
                    WHERE department_id = e.department_id)
ORDER BY e.department_id;

-- Top-K Query
-- ROWNUM: 레코드의 순서를 가리키는 가상의 컬럼(Pseudo)

-- 2007년 입사자 중에서 급여 순위 5위까지 출력
SELECT rownum 순위, first_name 이름
FROM (SELECT * FROM employees
        WHERE hire_date LIKE '07%'
        ORDER BY salary DESC, first_name)
WHERE rownum <= 5;

-- 집합 연산: SET
-- UNION: 합집합, UNION ALL: 합집합, 중복 요소 체크 안 함(별개로 봄)
-- INTERSECT: 교집합
-- MINUS: 차집합

-- 05/01/01 이전 입사자 쿼리
SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'; -- 24명
-- 급여를 12000 초과 수령 사원
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000; -- 8명

SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
UNION -- 합집합
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;   -- 26개


SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
UNION ALL -- 합집합: 중복 허용
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;   -- 32


SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
INTERSECT -- 교집합(AND)
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;   --  6


SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
MINUS -- 차집합
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;   -- 18


