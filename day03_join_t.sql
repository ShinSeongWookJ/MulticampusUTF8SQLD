-- day03_join.sql

부서테이블과 사원테이블을 조인해보자

select d.deptno, dname, e.deptno, ename, job, sal
from dept d, emp e
where d.deptno = e.deptno order by 1;

명시적 조인절을 이용한 조인 => 표준

select d.*, e.*
from dept d join emp e
on d.deptno = e.deptno order by d.deptno;

-- SALESMAN의 사원번호,이름,급여,부서명,근무지를 출력하여라.

select EMPNO, ENAME, SAL, JOB, DNAME, LOC
from emp e, dept d
where e.deptno = d.deptno and e.job='SALESMAN';

select EMPNO, ENAME, SAL, JOB, DNAME, LOC
FROM EMP E JOIN DEPT D
ON E.DEPTNO=D.DEPTNO 
WHERE E.JOB='SALESMAN';


--서로 연관이 있는 카테고리 테이블과 상품 테이블을 이용하여 각 상품별로 카테고리
--	      이름과 상품 이름을 함께 보여주세요.
SELECT CATEGORY_NAME, PRODUCTS_NAME
FROM CATEGORY C JOIN PRODUCTS P
ON C.CATEGORY_CODE = P.CATEGORY_FK ORDER BY 1;

--카테고리 테이블과 상품 테이블을 조인하여 화면에 출력하되 상품의 정보 중
--	      제조업체가 삼성인 상품의 정보만 추출하여 카테고리 이름과 상품이름, 상품가격
--	      제조사 등의 정보를 화면에 보여주세요.
SELECT CATEGORY_NAME, PRODUCTS_NAME, OUTPUT_PRICE, COMPANY
FROM CATEGORY C JOIN PRODUCTS P
ON C.CATEGORY_CODE = P.CATEGORY_FK AND P.COMPANY='삼성';
          
--각 상품별로 카테고리 및 상품명, 가격을 출력하세요. 단 카테고리가 'TV'인 것은 
--	      제외하고 나머지 정보는 상품의 가격이 저렴한 순으로 정렬하세요    
select category_name, products_name, output_price
from category c join products p
on c.category_name != 'TV' and c.category_code = p.category_fk order by 3;


SELECT D.DNAME, E.ENAME
FROM DEPT D JOIN EMP E
USING(DEPTNO);


# NON-EQUIJOIN
조인조건이EQUAL(=)이 아닌 다른 연산기호로 만들어지는 경우

EMP와 SALGRADE를 조인할 경우
EMP의 SAL ==> SALGRADE의 LOSAL ~ HISAL 사이에 있음

SELECT EMPNO, ENAME,SAL, GRADE, LOSAL, HISAL
FROM EMP E JOIN SALGRADE S
ON E.SAL BETWEEN S.LOSAL AND S.HISAL;


97] 공급업체 테이블과 상품 테이블을 조인하여 공급업체 이름, 상품명,
		공급가를 표시하되 상품의 공급가가 100000원 이상의 상품 정보
		만 표시하세요. 단, 여기서는 공급업체A와 공급업체B가 모두 표시
		되도록 해야 합니다.

SELECT EP_NAME, PRODUCTS_NAME, INPUT_PRICE
FROM SUPPLY_COMP S JOIN PRODUCTS P
ON (S.EP_NAME='공급업체A' OR S.EP_NAME='공급업체B') 
AND P.INPUT_PRICE >=100000;

#CARTESIAN PRODUCT
SELECT D.*, E.*
FROM DEPT D, EMP E;


SELECT D.*, E.*
FROM DEPT D, EMP E
WHERE D.DEPTNO= E.DEPTNO;

# OUTER JOIN
EQUAL 조건에 만족하지 않는 데이터가 있더라도  NULL로 설정하여 출력해줌

SELECT D.DEPTNO, DNAME, ENAME, JOB
FROM DEPT D, EMP E
WHERE D.DEPTNO = E.DEPTNO(+) ORDER BY 1;

명시적 조인절일 경우
[1] LEFT OUTER JOIN : 왼쪽 테이블을 기준으로 출력
[2] RIGHT OUTER JOIN : 오른쪽 테이블을 기준으로 출력
[3] FULL OUTER JOIN: 양쪽 다 아우터 조인을 거는 경우

[1] LEFT OUTER JOIN
SELECT  DISTINCT(E.DEPTNO), D.DEPTNO
FROM DEPT D LEFT OUTER JOIN EMP E
ON D.DEPTNO = E.DEPTNO ORDER BY 2;

[2] RIGHT OUTER JOIN
SELECT  DISTINCT(E.DEPTNO), D.DEPTNO
FROM DEPT D RIGHT OUTER JOIN EMP E
ON D.DEPTNO = E.DEPTNO ORDER BY 2;
        
[3] FULL OUTER JOIN
SELECT DISTINCT(E.DEPTNO), D.DEPTNO
FROM DEPT D FULL OUTER JOIN EMP E
ON D.DEPTNO = E.DEPTNO ORDER BY 2;

--문제98] 상품테이블의 모든 상품을 공급업체, 공급업체코드, 상품이름, 
--          상품공급가, 상품 판매가 순서로 출력하되 공급업체가 없는
--          상품도 출력하세요(상품을 기준으로).
SELECT S.EP_CODE, EP_NAME, PRODUCTS_NAME, INPUT_PRICE, OUTPUT_PRICE
FROM SUPPLY_COMP S RIGHT OUTER JOIN PRODUCTS P
ON S.EP_CODE = P.EP_CODE_FK;
--
--	문제99] 상품테이블의 모든 상품을 공급업체, 카테고리명, 상품명, 상품판매가
--		순서로 출력하세요. 단, 공급업체나 상품 카테고리가 없는 상품도
--		출력합니다.

SELECT EP_NAME, CATEGORY_NAME, PRODUCTS_NAME, OUTPUT_PRICE
FROM SUPPLY_COMP S RIGHT OUTER JOIN PRODUCTS P
ON S.EP_CODE = P.EP_CODE_FK
LEFT OUTER JOIN CATEGORY C
ON P.CATEGORY_FK = C.CATEGORY_CODE;

# SELF JOIN
자기 테이블과 조인하는 경우
각 사원의 정보를 출력하되 사원들의 관리자 이름도 함께 보여주세요

SELECT E.EMPNO, E.ENAME, E.MGR, M.EMPNO, M.ENAME "MANAGER"
FROM EMP E JOIN EMP M
ON E.MGR = M.EMPNO;

--[문제] emp테이블에서 "누구의 관리자는 누구이다"는 내용을 출력하세요.

SELECT E.ENAME||'의 관리자는 '||M.ENAME||'이다' 
FROM EMP E JOIN EMP M
ON E.MGR=M.EMPNO;

#UNION: 합집합
SELECT DEPTNO FROM DEPT UNION
SELECT DEPTNO FROM EMP;

#UNION ALL
SELECT DEPTNO FROM DEPT UNION ALL
SELECT DEPTNO FROM EMP;

#INTERSECT : 교집합
SELECT DEPTNO FROM DEPT
INTERSECT SELECT DEPTNO FROM EMP;

#MINUS : 차집합
SELECT DEPTNO FROM DEPT MINUS
SELECT DEPTNO FROM EMP;

--1. emp테이블에서 모든 사원에 대한 이름,부서번호,부서명을 출력하는 
--   문장을 작성하세요.

--2. emp테이블에서 NEW YORK에서 근무하고 있는 사원에 대하여 이름,업무,급여,
--    부서명을 출력하는 SELECT문을 작성하세요.
SELECT ENAME, JOB, SAL, DNAME, LOC
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO AND D.LOC='NEW YORK';

--3. EMP테이블에서 보너스를 받는 사원에 대하여 이름,부서명,위치를 출력하는
--    SELECT문을 작성하세요.
SELECT ENAME, DNAME, LOC, COMM
FROM DEPT D JOIN EMP E
ON D.DEPTNO = E.DEPTNO AND COMM IS NOT NULL;

--5. 아래의 결과를 출력하는 문장을 작성하에요(관리자가 없는 King을 포함하여
--	모든 사원을 출력)

select e.ename Employee, e.empno "Emp#",
m.ename Manager, m.empno "Mgr#"
from emp e left outer join emp m
on e.mgr = m.empno order by 3 desc;

select e.ename Employee, e.empno "Emp#",
m.ename Manager, m.empno "Mgr#"
from emp e, emp m
where e.mgr = m.empno(+) order by 3 desc;
	---------------------------------------------
	Emplyee		Emp#		Manager	Mgr#
	---------------------------------------------
	KING		7839
	BLAKE		7698		KING		7839
	CKARK		7782		KING		7839
	.....
	---------------------------------------------

select ep_name,category_fk,products_name,output_price
from supply_comp sc full outer join products p
on sc.ep_code=p.ep_code_fk;


