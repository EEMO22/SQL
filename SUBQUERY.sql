----------
-- SUBQUERY
----------
-- �ϳ��� ���ǹ� �ȿ� �ٸ� ���ǹ��� �����ϴ� ����

-- ��ü ��� ��, �޿��� �߾Ӱ����� ���� �޴� ���

-- 1. �޿��� �߾Ӱ�?
SELECT MEDIAN(salary) FROM employees;   --  6200
-- 2. 6200���� ���� �޴� ��� ����
SELECT first_name, salary FROM employees WHERE salary > 6200;

-- 3. �� ������ ��ģ��.
SELECT first_name, salary FROM employees
WHERE salary > (SELECT MEDIAN(salary) FROM employees);

-- Den ���� �ʰ� �Ի��� �����
-- 1. Den �Ի��� ����
SELECT hire_date FROM employees WHERE first_name = 'Den'; -- 02/12/07
-- 2. Ư�� ��¥ ���� �Ի��� ��� ����
SELECT first_name, hire_date FROM employees WHERE hire_date >= '02/12/07';
-- 3. �� ������ ��ģ��.
SELECT first_name, hire_date 
FROM employees 
WHERE hire_date >= (SELECT hire_date FROM employees WHERE first_name = 'Den');

-- ������ ���� ����
-- ���� ������ ��� ���ڵ尡 �� �̻��� ���� ���� ������ �����ڸ� ����� �� ����
-- IN, ANY, ALL, EXISTS �� ���� �����ڸ� Ȱ��
SELECT salary FROM employees WHERE department_id = 110; -- 2 ROW

SELECT first_name, salary FROM employees
WHERE salary = (SELECT salary FROM employees WHERE department_id = 110); -- ERROR

-- ����� �������̸� ���� �����ڸ� Ȱ��
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
-- �ܺ� ������ ���� ������ �������踦 �δ� ����
SELECT e.department_id, e.employee_id, e.first_name, e.salary
FROM employees e
WHERE e.salary = (SELECT MAX(salary) FROM employees
                    WHERE department_id = e.department_id)
ORDER BY e.department_id;

-- Top-K Query
-- ROWNUM: ���ڵ��� ������ ����Ű�� ������ �÷�(Pseudo)

-- 2007�� �Ի��� �߿��� �޿� ���� 5������ ���
SELECT rownum ����, first_name �̸�
FROM (SELECT * FROM employees
        WHERE hire_date LIKE '07%'
        ORDER BY salary DESC, first_name)
WHERE rownum <= 5;

-- ���� ����: SET
-- UNION: ������, UNION ALL: ������, �ߺ� ��� üũ �� ��(������ ��)
-- INTERSECT: ������
-- MINUS: ������

-- 05/01/01 ���� �Ի��� ����
SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'; -- 24��
-- �޿��� 12000 �ʰ� ���� ���
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000; -- 8��

SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
UNION -- ������
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;   -- 26��


SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
UNION ALL -- ������: �ߺ� ���
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;   -- 32


SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
INTERSECT -- ������(AND)
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;   --  6


SELECT first_name, salary, hire_date FROM employees WHERE hire_date < '05/01/01'
MINUS -- ������
SELECT first_name, salary, hire_date FROM employees WHERE salary > 12000;   -- 18


