-- ORACLE Database 답안지
-- 수강생 이름: 강호진

-- A11.
SELECT emp.last_name, emp.salary, dept.department_name
FROM employees emp LEFT OUTER JOIN departments dept
                                ON emp.department_id = dept.department_id 
WHERE commission_pct IS NOT NULL;


-- A12.
SELECT emp.last_name, emp.salary, emp.job_id
FROM employees emp 
WHERE emp.manager_id = (SELECT employee_id
                            FROM employees mgr
                        WHERE last_name = 'King' AND manager_id IS NULL);


-- A13.
SELECT emp.last_name, emp.salary
FROM employees emp JOIN employees mgr
                    ON emp.manager_id = mgr.employee_id
WHERE emp.salary > mgr.salary;


-- A14.
SELECT MIN(salary) min, 
    MAX(salary) max, 
    SUM(salary) sum, 
    ROUND(AVG(salary), 0) avg
FROM employees;


-- A15.
SELECT emp.last_name, emp.salary
FROM employees emp JOIN (SELECT department_id, AVG(salary) salary
                            FROM employees
                         GROUP BY department_id) dept
                    ON emp.department_id = dept.department_id
WHERE emp.salary < dept.salary;



