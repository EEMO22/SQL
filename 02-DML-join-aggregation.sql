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
SELECT emp.employee_id,
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


------------------
-- 집계 함수
------------------

-- 여러 레코드로부터 데이터를 수집, 하나의 결과 행을 반환

-- count: 갯수 세기
SELECT count(*) FROM employees; -- 특정 컬럼이 아닌 레코드의 갯수

SELECT count(commission_pct) FROM employees; -- 해당 컬럼이 null 이 아닌 갯수
SELECT count (*) FROM employees -- * 를 통해 내부입력되어 단일행 함수로 리턴한다
WHERE commission_pct IS NOT NULL;

-- sum: 합계
SELECT sum(salary) FROM employees;

-- avg: 평균
-- 급여의 평균
SELECT avg(salary) FROM employees;
-- avg 함수는 null 값은 집계에서 제외

-- 사원들의 평균 커미션 비율
SELECT avg(commission_pct) FROM employees;  -- 22%
SELECT avg(nvl(commission_pct, 0)) FROM employees; -- 7%

-- min/max: 최소값, 최대값
SELECT min(salary), max(salary), avg(salary), median(salary)
FROM employees;

-- 일반적 오류
SELECT department_id, avg(salary)
FROM employees; -- ERROR

-- 수정: 집계함수
SELECT department_id, avg(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 집계 함수를 사용한 SELECT 문의 컬럼 목록에는 
-- Group bby 에 참여한 필드, 집계 함수만 올 수 있다.

-- 부서별 평균 급여를 출력,
-- 평균 급여가 7000 이상인 부서만 뽑아봅시다.
SELECT department_id, avg(salary)
FROM employees
WHERE avg(salary) >= 7000
GROUP BY department_id; --  ERROR
-- 집계 함수 실행 이전에 WHERE 절을 검사하기 때문에
-- 집계 함수는 WHERE 절에서 사용할 수 없다.

-- 집계 함수 실행 이후에 조건 검사하려면
-- HAVING 절을 이용

SELECT department_id, ROUND(avg(salary), 2)
FROM employees
GROUP BY department_id
    HAVING avg(salary) >= 7000
ORDER BY department_id;

-------------------
-- 분석 함수
-------------------

-- ROLLUP
-- 그룹핑 된 결과에 대한 상세 요약을 제공하는 기능
-- 일종의 ITEM Total
SELECT department_id,
    job_id,
    SUm(salary)
FROM employees
GROUP BY ROLLUP(department_id, job_id);

-- CUVE 함수
-- Cross Table 에 대한 Summary 를 함께 추출
-- ROLLUP 함수에서 추출되는 Item Total 과 함께
-- Column Total 값을 함께 추출
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY department_id;










------------------------------------------------------------------
-- 문제 1.
-- 직원들의 사번(employee_id), 이름(firt_name), 성(last_name)과 부서명(department_name)을
-- 조회하여 부서이름(department_name) 오름차순, 사번(employee_id) 내림차순 으로 정렬하세요.
-- (106건)

SELECT emp.employee_id 사번, 
    emp.first_name || ' ' || emp.last_name 이름,
    dept.department_name 부서이름
FROM employees emp, departments dept
WHERE dept.department_id = emp.department_id
ORDER BY department_name ASC, employee_id DESC;

-- 문제 2.
-- employees 테이블의 job_id는 현재의 업무아이디를 가지고 있습니다.
-- 직원들의 사번(employee_id), 이름(firt_name), 급여(salary), 부서명(department_name), 
-- 현재업무(job_title)를 사번(employee_id) 오름차순 으로 정렬하세요.
-- 부서가 없는 Kimberely(사번 178)은 표시하지 않습니다.
-- (106건)

SELECT emp.employee_id,
    emp.first_name,
    emp.salary,
    dept.department_name,
    jobs.job_title,
FROM 





