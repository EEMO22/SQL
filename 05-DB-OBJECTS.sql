-------------
-- DB OBJECTS
-------------

-- VIEW
-- SYSTEM 계정으로 수행
-- create view 권한 필요

GRANT create view TO C##BITUSER;

-- C##BITUSER 전환
-- HR.employees 테이블로부터 department_id = 10 사원의 view 생성
CREATE TABLE emp_123
    AS SELECT * FROM HR.employees
        WHERE department_id IN (10, 20, 30);
        
-- simple View 생성
CREATE OR REPLACE VIEW emp_20
    AS SELECT employee_id, first_name, last_name, salary
        FROM emp_123
        WHERE department_id = 20;
        
DESC emp_20;

-- 마치 일반 테이블처럼 SELECT 할 수 있다.
SELECT employee_id, first_name, salary FROM emp_20;

-- SIMPLE VIEW는 제약 사항에 위배되지 않으면 내용 갱신 가능
UPDATE emp_20 SET salary = salary * 2;
SELECT first_name, salary FROM emp_123 WHERE department_id = 20; -- 베이스 테이블 데이터가 변경


-- 가급적 VIEW는 조회 전용으로 사용하기를 권장
-- WITH READ ONLY 옵션
CREATE OR REPLACE VIEW emp_10
    AS SELECT employee_id, first_name, last_name, salary
    FROM emp_123
    WHERE department_id = 10
    WITH READ ONLY;

SELECT * FROM emp_10;
UPDATE emp_10 SET salary = salary * 2;

-- Complex View
CREATE OR REPLACE VIEW book_detail
    (book_id, title, author_name, pub_date)
    AS SELECT book_id, title, author_name, pub_date
        FROM book b, author a
        WHERE b.author_id = a.author_id;

SELECT * FROM book_detail;
SELECT * FROM author;

DESC book;
INSERT INTO book (book_id, title, author_id)
VALUES(1, '토지', 1);

INSERT INTO book (book_id, title, author_id)
VALUES(2, '살인자의 기억법', 2);

COMMIT;

-- Complex View로 조회
SELECT * FROM book_detail;

-- Complex View는 갱신이 불가
UPDATE book_detail SET author_name = '소설가'; --  ERROR

-- View의 삭제
-- book_detail은 book, author 테이블을 기반으로 함
DROP VIEW book_detail;  -- VIEW 삭제

SELECT * FROM tab;

-- VIEW 확인을 위한 DICTIONARY
SELECT * FROM USER_VIEWS;
SELECT * FROM USER_OBJECTS;

SELECT object_name, object_type, status FROM USER_OBJECTS
WHERE object_type = 'VIEW';




