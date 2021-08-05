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

SELECT empleoyee_id 직원번호, first_name 이름, 
    salary 급여, ROUND(AVG(salary), 2) 평균급여, MAX(salary) 최대급여
FROM employees 