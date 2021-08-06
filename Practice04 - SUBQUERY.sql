-- 문제 1.
-- 평균 급여보다 적은 급여을 받는 직원은 몇명인지 구하시요
-- (56건)

SELECT COUNT(salary)
FROM employees
WHERE salary < (SELECT AVG(salary) FROM employees); 

-- 문제 2.
-- 평균급여 이상, 최대급여 이하의 월급을 받는 사원의 직원번호(employee_id), 
-- 이름(first_name), 급여(salary), 평균급여, 최대급여를 급여의 오름차순으로 정렬하여 출력하세요
-- (51건)

SELECT employee_id 직원번호, first_name 이름, 
    salary 급여, AVG(salary) 평균급여, MAX(salary) 최대급여
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees)
GROUP BY employee_id, first_name, salary
ORDER BY salary ASC;

-- A

SELECT e.employee_id, e.first_name,
    e.salary, t.avgSalary, t.maxSalary
FROM employees e, (SELECT AVG(salary) avgSalary, MAX(salary) maxSalary
                        FROM employees)t
WHERE e.salary BETWEEN t.avgSalary AND t.maxSalary
ORDER BY salary;


-- 문제 3.
-- 직원중 Steven(first_name) king(last_name)이 소속된 부서(departments)가 있는 곳의 
-- 주소를 알아보려고 한다.
-- 도시아이디(location_id), 거리명(street_address), 우편번호(postal_code), 도시명(city), 
-- 주(state_province), 나라아이디(country_id) 를 출력하세요
-- (1건)


-- 해결
SELECT loc.location_id 도시아이디, loc.street_address 거리명, loc.postal_code 우편번호,
    loc.city 도시명, loc.state_province 주, cntr.country_id 나라아이디
FROM locations loc INNER JOIN countries cntr
                            ON cntr.country_id = loc.country_id
WHERE loc.location_id = (SELECT location_id
                            FROM departments
                         WHERE department_id = (SELECT department_id
                                                    FROM employees
                                                WHERE first_name = 'Steven' AND last_name = 'King'));

-- 소속 구하기
SELECT first_name, last_name, department_id
    FROM employees
WHERE first_name = 'Steven' AND last_name = 'King';

-- location_id 구하기                                           
SELECT location_id
    FROM departments
WHERE department_id = (SELECT department_id
                            FROM employees
                       WHERE first_name = 'Steven' AND last_name = 'King');
               
-- 도시 정보 구하기
SELECT loc.location_id 도시아이디, loc.street_address 거리명, loc.postal_code 우편번호,
    loc.city 도시명, loc.state_province 주
FROM locations loc 
WHERE loc.location_id = (SELECT location_id
                                FROM departments
                          WHERE department_id = (SELECT department_id
                                                        FROM employees
                                                   WHERE first_name = 'Steven' AND last_name = 'King'));

-- A

-- 쿼리1. Steven King이 소속된 부서
SELECT department_id FROM employees
WHERE first_name = 'Steven' AND last_name = 'King';

-- 쿼리2. Steven King 이 소속된 부서가 위치한 location 정보
SELECT location_id FROM departments
WHERE department_id = (SELECT department_id 
                        FROM employees
                        WHERE first_name = 'Steven' AND last_name = 'King');
                        
-- 최종 쿼리
SELECT location_id, street_address, postal_code, city, state_province,
    country_id
FROM locations
WHERE location_id = (SELECT location_id 
                        FROM departments
                     WHERE department_id = (SELECT department_id 
                                                FROM employees
                                            WHERE first_name = 'Steven' AND last_name = 'King'));



-- 문제 4.
-- job_id 가 'ST_MAN' 인 직원의 급여보다 작은 직원의 사번,이름,급여를 급여의 내림차순으로
-- 출력하세요 -ANY연산자 사용
-- (74건)

SELECT employee_id 사번, first_name 이름, salary 급여
FROM employees
WHERE salary <ANY (SELECT salary FROM employees WHERE job_id = 'ST_MAN')
ORDER BY salary DESC;


-- 문제 5.
-- 각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 이름(first_name)과 급여(salary) 
-- 부서번호(department_id)를 조회하세요
-- 단 조회결과는 급여의 내림차순으로 정렬되어 나타나야 합니다.
-- 조건절비교, 테이블조인 2가지 방법으로 작성하세요
-- (11건)

-- WHERE
SELECT employee_id 직원번호, first_name 이름, salary 급여, department_id 부서번호
FROM employees
WHERE (department_id, salary) IN (SELECT department_id, MAX(salary) 
                                    FROM employees GROUP BY department_id)
ORDER BY salary DESC;

-- JOIN
SELECT emp.employee_id 직원번호, emp.first_name 이름, 
    emp.salary 급여, emp.department_id 부서번호
FROM employees emp, (SELECT department_id, MAX(salary) salary
                                    FROM employees GROUP BY department_id) sal
WHERE emp.department_id = sal.department_id
    AND emp.salary = sal.salary
ORDER BY emp.salary DESC;

-- 문제 6. 
-- 각 업무(job) 별로 연봉(salary)의 총합을 구하고자 합니다.
-- 연봉 총합이 가장 높은 업무부터 업무명(job_title)과 연봉 총합을 조회하시오
-- (19건)

-- 쿼리 1.
SELECT job_id, SUM(salary) sumSalary
FROM employees
GROUP BY job_id;

-- 최종 쿼리
SELECT j.job_title 업무명, t.sumSalary "연봉 총합"
FROM jobs j, (SELECT job_id, SUM(salary) sumSalary 
                    FROM employees
              GROUP BY job_id) t
WHERE j.job_id = t.job_id
ORDER BY t.sumSalary DESC;

-- 문제 7.
-- 자신의 부서 평균 급여보다 연봉(salary)이 많은 직원의 직원번호(employee_id), 
-- 이름(first_name)과 급여(salary)을 조회하세요
-- (38건)

--쿼리 1 : 부서별 평균 급여
SELECT department_id, AVG(salary) salary
FROM employees
GROUP BY department_id;

-- 최종 쿼리
SELECT e.employee_id 직원번호, e.first_name 이름, e.salary 급여
FROM employees e, (SELECT department_id, AVG(salary) salary
                    FROM employees
                    GROUP BY department_id) t
WHERE e.department_id = t.department_id
    AND e.salary > t.salary;


-- 문제 8.
-- 직원 입사일이 11번째에서 15번째의 직원의 사번, 이름, 급여, 입사일을 입사일 순서로 출력하세요

-- 쿼리 1.

SELECT ROWNUM, employee_id , first_name , salary , hire_date
FROM employees
ORDER BY hire_date ASC; -- ROWNUM 이 정렬한 것을 ORDER BY 가 다시 자기 기준대로 섞어버림

-- 쿼리 2.

SELECT ROWNUM rn, employee_id, first_name, salary, hire_date
FROM (SELECT employee_id , first_name , salary , hire_date
        FROM employees
        ORDER BY hire_date ASC);

-- 최종 쿼리

SELECT rn, employee_id 사번, first_name 이름, salary 급여, hire_date 입사일
FROM (SELECT ROWNUM rn, employee_id, first_name, salary, hire_date
        FROM (SELECT employee_id , first_name , salary , hire_date
                FROM employees
                ORDER BY hire_date ASC))
WHERE rn BETWEEN 11 AND 15;








