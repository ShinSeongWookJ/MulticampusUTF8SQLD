create table emp_10
as
select * from emp where 1<>1;

select * from emp_10;

insert into emp_10 (empno, job, ename, hiredate,mgr, sal, comm, deptno)
values(1000,'MANAGER','TOM',SYSDATE,NULL,2000,NULL,10);
COMMIT;

DESC EMP_10;

ALTER TABLE EMP_10 ADD CONSTRAINT EMP_10_ENAME_NN NOT NULL(ENAME); --[X]

-- 컬럼을 수정하면서 NOT NULL을 추가
ALTER TABLE EMP_10 MODIFY ENAME VARCHAR2(20) NOT NULL;

INSERT INTO EMP_10(EMPNO,JOB,MGR, SAL, ENAME) VALUES(1001,'SALESMAN',1000,3000,'JAMES');

SELECT * FROM EMP_10;

-- SUBQUERY를 활용한 INSERT
INSERT INTO EMP_10
SELECT * FROM EMP WHERE DEPTNO=10;

INSERT절의 컬럼 개수와 서브쿼리의 컬럼 개수가 좌측에서부터 1대 1로 대응해야 하며
자료형과 크기가 같아야 한다.

SELECT * FROM EMP_10;

# UPDATE 문
UPDATE 테이블명 SET 컬럼명1=값1, .... WHERE 조건절;

--EMP테이블을 카피하여 EMP2테이블을 만들되 데이터와 구조를 모두 복사하세요
CREATE TABLE EMP2
AS
SELECT * FROM EMP;
SELECT * FROM EMP2;
ROLLBACK;
--EMP2에서 사번이 7788인 사원의 부서번호를 10번 부서로 수정하세요.
UPDATE EMP2 SET DEPTNO=10 WHERE EMPNO=7788;

--EMP2에서 사번이 7369인 사원의 부서를 30번 부서로 급여를 3500으로 수정하세요
UPDATE EMP2 SET DEPTNO=30, SAL=3500 WHERE EMPNO=7369;

ROLLBACK;

CREATE TABLE MEMBER2
AS SELECT * FROM MEMBER;

--2] 등록된 고객2 정보 중 고객의 나이를 현재 나이에서 모두 5를 더한 값으로 
--	      수정하세요.
update member2 set age = age+5;

--	 2_1] 고객2 중 13/09/01이후 등록한 고객들의 마일리지를 350점씩 올려주세요.
update member2 set mileage=mileage+350 where reg_date>'13/09/01';
SELECT * FROM MEMBER2;

--3] 등록되어 있는 고객2 정보 중 이름에 '김'자가 들어있는 모든 이름을 '김' 대신
--	     '최'로 변경하세요.
UPDATE MEMBER2 SET NAME=REPLACE(NAME,'김','최') WHERE NAME LIKE '김%';
SELECT * FROM MEMBER2;
ROLLBACK;

# UPDATE 할때 무결성제약조건을 신경써야 함

CREATE TABLE DEPT2
AS SELECT * FROM DEPT;

DEPT2테이블의 DEPTNO에 대해 PRIMARY KEY 제약조건을 추가하세요
ALTER TABLE DEPT2 ADD CONSTRAINT DEPT2_PK PRIMARY KEY (DEPTNO);

EMP2 테이블의 DEPTNO에 대해 FOREIGN KEY 제약조건을 추가하되
DEPT2의 DEPTNO를 외래키로 참조하도록 하세요

ALTER TABLE EMP2 ADD CONSTRAINT EMP2_FK FOREIGN KEY (DEPTNO)
REFERENCES DEPT2 (DEPTNO);

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME ='EMP2';

UPDATE EMP2 SET DEPTNO =10 WHERE DEPTNO=20;

SELECT * FROM EMP2;

UPDATE EMP2 SET DEPTNO =50 WHERE DEPTNO=20;
-- integrity constraint (SCOTT.EMP2_FK) violated - parent key not found

ROLLBACK;

# DELETE 문
DELETE FROM 테이블명 WHERE 조건절;

--- EMP2테이블에서 사원번호가 7499인 사원의 정보를 삭제하라.
DELETE FROM EMP2 WHERE EMPNO=7499;
SELECT * FROM EMP2;
ROLLBACK;
--- EMP2테이블의 자료 중 부서명이 'SALES'인 사원의 정보를 삭제하라.
DELETE FROM EMP2 WHERE DEPTNO = (SELECT DEPTNO FROM DEPT2 WHERE DNAME='SALES');

---- PRODUCTS2 를 만들어서 테스트하기
CREATE TABLE PRODUCTS2 AS SELECT * FROM PRODUCTS;

--1] 상품 테이블에 있는 상품 중 상품의 판매 가격이 10000원 이하인 상품을 모두 
--	      삭제하세요.
SELECT * FROM PRODUCTS2;

DELETE FROM PRODUCTS2 WHERE OUTPUT_PRICE <= 10000;

--	2] 상품 테이블에 있는 상품 중 상품의 대분류가 도서인 상품을 삭제하세요.

DELETE FROM PRODUCTS2 WHERE CATEGORY_FK 
= ( SELECT CATEGORY_CODE FROM CATEGORY WHERE CATEGORY_NAME LIKE '%도서%' 
AND MOD(CATEGORY_CODE,100)=0);

DELETE FROM PRODUCTS2;
 -- WHERE 조건절이 없으면 모든 레코드가 삭제된다.
COMMIT;


TCL : TRANSACTION CONTROL LANGUAGE
- COMMIT
- ROLLBACK
- SAVEPOINT (표준 아님. 오라클에만 있음)

UPDATE EMP2 SET ENAME='CHARSE' WHERE EMPNO=7788;
SELECT * FROM EMP2;

UPDATE EMP2 SET DEPTNO=30 WHERE EMPNO=7788;

--SAVEPOINT 포인트명;
SAVEPOINT POINT1; -- 저장점 설정

UPDATE EMP2 SET JOB='MANAGER';

ROLLBACK TO SAVEPOINT POINT1;

SELECT * FROM EMP2;
COMMIT;
