-- day02_select.sql
select * from tab;
select * from emp;
select * from dept;
select * from salgrade;

SELECT EMPNO, ENAME, SAL, SAL+500 AS SAL_UP, 
COMM, SAL*12+COMM, SAL*12+NVL(COMM, 0) "1 YEAR SAL"   
FROM EMP;
--NVL()
--NVL2(EXPR, 값1, 값2) :  EXPR이 NULL이 아닐경우 값1을 반환, NULL일경우는 값2를 반환
SELECT EMPNO, ENAME, MGR, NVL2(MGR,'관리자있음','관리자없음') "관리자 여부" FROM EMP;

--문자열 결합: ||

SELECT ENAME|| ' IS A ' ||JOB AS "EMPLOYEE INFO" FROM EMP;

--문제] EMP테이블에서 이름과 연봉을 "KING: 1 YEAR SALARY = 60000"
--	형식으로 출력하라.

SELECT ENAME||': 1 YEAR SALARY='|| TO_CHAR(SAL*12+NVL(COMM,0)) FROM EMP;
SELECT ENAME||': 1 YEAR SALARY='|| SAL*12 FROM EMP;

--DISTINCT : 중복행을 제거함
SELECT JOB FROM EMP;
SELECT DISTINCT JOB FROM EMP;

부서별로 담당 하는 업무를 한번씩 출력하세요
SELECT DEPTNO, JOB FROM EMP ORDER BY DEPTNO ASC;
SELECT DISTINCT DEPTNO,JOB FROM EMP
ORDER BY DEPTNO;

SELECT DISTINCT NAME, JOB FROM MEMBER;
SELECT UNIQUE NAME,JOB FROM MEMBER;
--[문제]
--	 1] EMP테이블에서 중복되지 않는 부서번호를 출력하세요.
SELECT DISTINCT DEPTNO FROM EMP;
--	 2] MEMBER테이블에서 회원의 이름과 나이 직업을 보여주세요.
SELECT NAME, AGE FROM MEMBER;
--	 3] CATEGORY 테이블에 저장된 모든 내용을 보여주세요.
SELECT * FROM CATEGORY;
--	 4] MEMBER테이블에서 회원의 이름과 적립된 마일리지를 보여주되,
--	      마일리지에 13을 곱한 결과를 "MILE_UP"이라는 별칭으로
--	      함께 보여주세요.
SELECT NAME, MILEAGE, MILEAGE*13 MILE_UP FROM MEMBER;

# 특정 행 검색 - WHERE절 사용해서 조건을 부여할 수 있다.

EMP에서 급여가 3000이상인 사원의 사번,이름,업무, 급여를 출력하세요.
SELECT EMPNO, ENAME, JOB, SAL
FROM EMP
WHERE SAL >= 3000;

--EMP테이블에서 담당업무가 MANAGER인 사원의
--정보를 사원번호,이름,업무,급여,부서번호로 출력하세요.
SELECT EMPNO, ENAME, JOB, SAL, DEPTNO
FROM EMP
WHERE JOB=upper('manager');

sql문은 대소문자 구분하지 않지만, 값(리터럴)은 대소문자를 구분한다.

--EMP테이블에서 1982년 1월1일 이후에 입사한 사원의 
--사원번호,성명,업무,급여,입사일자를 출력하세요
SELECT EMPNO,ENAME,JOB,SAL, HIREDATE
FROM EMP
WHERE HIREDATE > '82/01/01';

--emp테이블에서 급여가 1300에서 1500사이의 사원의 이름,업무,급여,
--	부서번호를 출력하세요.
SELECT ENAME, JOB, SAL, DEPTNO
FROM EMP
WHERE SAL >=1300 AND SAL <=1500;

SELECT ENAME, JOB, SAL, DEPTNO
FROM EMP
WHERE SAL BETWEEN 1300 AND 1500;

--emp테이블에서 사원번호가 7902,7788,7566인 사원의 사원번호,
--	이름,업무,급여,입사일자를 출력하세요.
SELECT EMPNO,ENAME, JOB
FROM EMP
WHERE EMPNO IN (7902,7788,7566);
--WHERE EMPNO=7902 OR EMPNO=7788 OR EMPNO=7566;

--10번 부서가 아닌 사원의 이름,업무,부서번호를 출력하세요
SELECT ENAME, JOB, DEPTNO
FROM EMP WHERE DEPTNO <> 10;

--  emp테이블에서 업무가 SALESMAN 이거나 PRESIDENT인
--	사원의 사원번호,이름,업무,급여를 출력하세요.
select empno, ename, job, sal
from emp
where job ='SALESMAN' or job='PRESIDENT';
--	커미션(COMM)이 300이거나 500이거나 1400인 사원정보를 출력하세요
select * from emp
where comm in (300,500,1400);
	
--	커미션이 300,500,1400이 아닌 사원의 정보를 출력하세요
select * from emp
where comm not in (300,500,1400);

-- 커미션이 null인 사원의 정보를 출력하세요
--select * from emp where comm=null; [x]
select * from emp where comm is null;
--null값의 비교는 is null or is not null 로 비교한다

--emp에서 이름이 S자로 시작하는 사람 정보를 보여주세요
select * from emp
where ename like 'S%';

select * from emp
where ename like '%S';

--	-이름 중 S자가 들어가는 사람의 정보를 보여주세요.
select ename from emp
where ename like '%S%';
--  이름의 두번 째에 O자가 들어가는 사람의 정보를 보여주세요.
select ename from emp
where ename like '_O%';

-- EMP테이블에서 입사일자가 82년도에 입사한 사원의 사번,이름,업무
--	   입사일자를 출력하세요.
select empno, ename, job, hiredate from emp
where hiredate like '82%';

alter session set nls_date_format='yyyy-mm-dd';
alter session set nls_date_format='dd-mon-yy';
alter session set nls_date_format='yy/mm/dd';

select hiredate from emp;

-- 고객 테이블 가운데 성이 김씨인 사람의 정보를 보여주세요.
    select * from member where name like '김%';
-- 고객 테이블 가운데 '강북'가 포함된 정보를 보여주세요.
    select * from member where addr like '%강북%';
-- 카테고리 테이블 가운데 category_code가 0000로 끝는 상품정보를 보여주세요.
select * from category
where category_code like '%0000';

select * from products
where category_fk  like '%0000';

--- EMP테이블에서 급여가 1100이상이고 JOB이 MANAGER인 사원의
--	사번,이름,업무,급여를 출력하세요.
select empno, ename, job, sal
from emp
where sal >= 1100 and job='MANAGER';

--	- EMP테이블에서 급여가 1100이상이거나 JOB이 MANAGER인 사원의
--	사번,이름,업무,급여를 출력하세요.
select empno, ename, job, sal
from emp
where sal >= 1100 or job='MANAGER';
--	- EMP테이블에서 JOB이 MANAGER,CLERK,ANALYST가 아닌
--	  사원의 사번,이름,업무,급여를 출력하세요.    
select empno,ename,job, sal
from emp
where job not in ('MANAGER','CLERK','ANALYST');

select empno,ename,job, sal
from emp
WHERE job <>'MANAGER' AND JOB <>'CLERK' AND JOB != 'ANALYST';

--	- EMP테이블에서 급여가 1000이상 1500이하가 아닌 사원의 정보를 보여주세요
SELECT * FROM EMP WHERE SAL NOT BETWEEN 1000 AND 1500;

--   - EMP테이블에서 이름에 'S'자가 들어가지 않은 사람의 이름을 모두
--	  출력하세요.
select ename
from emp
where ename not like '%S%';
--	- 사원테이블에서 업무가 PRESIDENT이고 급여가 1500이상이거나
--	   업무가 SALESMAN인 사원의 사번,이름,업무,급여를 출력하세요.
SELECT EMPNO, ENAME, JOB, SAL
FROM EMP
WHERE JOB='PRESIDENT' AND SAL >=1500 OR JOB='SALESMAN';

연산자 우선순위
비교연산자 > NOT > AND > OR 

ORDER BY 절
- 오름차순 : ASC
- 내림차순 : DESC
- NULL 값은 오름차순일 때 가장 나중에, 내림차순에선 가장 먼저온다

WGHO 순서
- WHERE
- GROUP BY
- HAVING
- ORDER BY

--사원테이블에서 입사일자 순으로 정렬하여 사번,이름,업무,급여,
--	입사일자를 출력하세요.
SELECT EMPNO, ENAME,JOB, SAL, HIREDATE
FROM EMP ORDER BY HIREDATE;

SELECT EMPNO, ENAME,JOB, SAL, HIREDATE
FROM EMP ORDER BY HIREDATE DESC;

SELECT EMPNO,ENAME,SAL, SAL*12 FROM EMP ORDER BY SAL*12 DESC;

SELECT EMPNO,ENAME,SAL, SAL*12 Y FROM EMP ORDER BY Y DESC;
SELECT EMPNO,ENAME,SAL, SAL*12 FROM EMP
ORDER BY 4 DESC;
--사원 테이블에서 부서번호로 정렬한 후 부서번호가 같을 경우
--	급여가 많은 순으로 정렬하여 사번,이름,업무,부서번호,급여를
--	출력하세요.
SELECT EMPNO, ENAME, JOB, DEPTNO, SAL
FROM EMP
ORDER BY DEPTNO ASC, SAL DESC;

--	사원 테이블에서 첫번째 정렬은 부서번호로, 두번째 정렬은
--	업무로, 세번째 정렬은 급여가 많은 순으로 정렬하여
--	사번,이름,입사일자,부서번호,업무,급여를 출력하세요.
SELECT EMPNO, ENAME, HIREDATE, DEPTNO, JOB, SAL
FROM EMP
ORDER BY DEPTNO, JOB, SAL DESC;

--1] 상품 테이블에서 판매 가격이 저렴한 순서대로 상품을 정렬해서 
--    보여주세요.
select * from products order by output_price asc;

--2] 고객 테이블의 정보를 이름의 가나다 순으로 정렬해서 보여주세요.
--      단, 이름이 같을 경우에는 나이가 많은 순서대로 보여주세요.
select * from member order by name asc, age desc;

--3] 상품 테이블에서 배송비의 내림차순으로 정렬하되, 
--	    같은 배송비가 있는 경우에는
--		마일리지의 내림차순으로 정렬하여 보여주세요.
select * from products order by trans_cost desc, mileage desc;

--4]사원테이블이서 입사일이 1981 2월20일 ~ 1981 5월1일 사이에
--	    입사한 사원의 이름,업무 입사일을 출력하되, 입사일 순으로 출력하세요.
select ename,job,hiredate from emp 
where TO_CHAR(HIREDATE,'YY/MM/DD') >='81/02/20' AND
TO_CHAR(HIREDATE,'YY/MM/DD') <='81/05/01';

select ename,job,hiredate from emp 
where TO_CHAR(HIREDATE,'YY/MM/DD') BETWEEN '81/02/20' AND '81/05/01';

select ename,job,hiredate
from emp where hiredate between '1981-02-20' and '1981-05-01'
order by hiredate asc;

SELECT HIREDATE FROM EMP;
--5] 사원테이블에서 부서번호가 10,20인 사원의 이름,부서번호,업무를 출력하되
--	    이름 순으로 정렬하시오.

select ename,deptno,job from emp where deptno in(10,20) order by ename asc;

--6] 사원테이블에서 보너스가 급여보다 10%가 많은 사원의 이름,급여,보너스
--    를 출력하세요.
SELECT ENAME, SAL, COMM
FROM EMP
WHERE COMM > SAL *1.1;
--WHERE COMM  >  SAL+ SAL *10/100;

--7] 사원테이블에서 업무가 CLERK이거나 ANALYST이고
--     급여가 1000,3000,5000이 아닌 모든 사원의 정보를 
SELECT * FROM EMP
WHERE JOB IN ('CLERK','ANALYST') AND SAL NOT IN (1000,3000,5000);
--
--8] 사원테이블에서 이름에 L이 두자가 있고 부서가 30이거나
--    또는 관리자가 7782번인 사원의 정보를 출력하세요.
SELECT * FROM EMP
WHERE ENAME LIKE '%LL%' AND DEPTNO =30 OR MGR=7782;
