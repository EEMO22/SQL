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



-- 평균 급여보다 많이 받는 사람들
SELECT employee_id 직원번호, first_name 이름, 
    salary 급여, AVG(salary) 평균급여, MAX(salary) 최대급여
FROM employees
WHERE salary >= (SELECT AVG(salary) FROM employees)
GROUP BY employee_id, first_name, salary
ORDER BY salary ASC;

-- 최고 급여보다 적게 받는 사람들
SELECT employee_id 직원번호, first_name 이름, 
    salary 급여, AVG(salary) 평균급여, MAX(salary) 최대급여
FROM employees
WHERE salary <= (SELECT MAX(salary) FROM employees)
GROUP BY employee_id, first_name, salary
ORDER BY salary ASC;

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













