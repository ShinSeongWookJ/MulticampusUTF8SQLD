# subquery

-- 사원테이블에서 scott의 급여보다 많은 사원의 사원번호,이름,업무
--	급여를 출력하세요.

select sal from emp where ename=upper('scott');

select empno, ename, job, sal from emp
where sal >3000;

select empno, ename, job, sal from emp
where sal > ( select sal from emp where ename=upper('scott') );


  select empno,ename,job,sal from emp
  where sal > (select sal from emp where ename=upper('scott'));

# 단일행을 반환하는 서브쿼리

문제2]사원테이블에서 급여의 평균보다 적은 사원의 사번,이름
	업무,급여,부서번호를 출력하세요.
select empno, ename, job, sal, deptno
from emp
where sal < ( select avg(sal) from emp   );
    
--사원테이블에서 사원의 급여가 20번 부서의 최소급여
--		보다 많은 부서를 출력하세요.    
select deptno, min(sal)
from emp 
group by deptno
having min(sal) > ( select min(sal) from emp where deptno=20 );

# 다중행 서브쿼리
: 서브쿼리가 1개 이상의 행을 반환하는 경우
=> 다중행서브쿼리 연산자를 사용해야 한다.
   in 연산자
   any
   all
   exists
--    - 업무별로 최대 급여를 받는 사원의 
--	 사원번호와 이름을 출력하세요.
select job, empno, ename, sal from emp
where  (job, sal) in (
select job, max(sal)
from emp group by job
) order by 1;

# any 연산자

select deptno, ename, sal from emp
where deptno <> 20 and sal > ANY (select sal from emp where job='SALESMAN');

==> SALESMAN인 사원의 최소급여보다 많으면서 20번부서가 아닌 사원정보를 출력하란 의미

# ALL 연산자

select deptno, ename, sal from emp
where deptno <> 20 and sal > ALL (select sal from emp where job='SALESMAN');

==> SALESMAN인 사원의 최대급여보다 많으면서 20번부서가 아닌 사원정보를 출력하란 의미

# EXISTS : 서브쿼리 데이터 존재여부를 따져 존재하는 값들만 결과로 반환한다
-- 관리자 정보를 가져와 보여주세요
SELECT EMPNO, ENAME, SAL FROM EMP E
WHERE EXISTS ( SELECT EMPNO FROM EMP WHERE E.EMPNO = MGR  );

# 다중열 서브쿼리

부서별로 최소급여를 받는 사원의 사번,이름,급여,부서번호를 출력하세요
SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE (DEPTNO, SAL ) IN
(SELECT DEPTNO, MIN(SAL)
FROM EMP
GROUP BY DEPTNO);

--84] 고객 테이블에 있는 고객 정보 중 마일리지가 
--	가장 높은 금액의 고객 정보를 보여주세요.
SELECT * FROM MEMBER
WHERE MILEAGE = (SELECT MAX(MILEAGE) FROM MEMBER);

--	85] 상품 테이블에 있는 전체 상품 정보 중 상품의 판매가격이 
--	    판매가격의 평균보다 큰  상품의 목록을 보여주세요. 
--	    단, 평균을 구할 때와 결과를 보여줄 때의 판매 가격이
--	    50만원을 넘어가는 상품은 제외시키세요.

SELECT * FROM PRODUCTS
WHERE OUTPUT_PRICE > 
( SELECT AVG(OUTPUT_PRICE) FROM PRODUCTS WHERE OUTPUT_PRICE<=500000)
AND OUTPUT_PRICE <=500000;

--	86] 상품 테이블에 있는 판매가격에서 평균가격 이상의 상품 목록을 구하되 평균을
--	    구할 때 판매가격이 최대인 상품을 제외하고 평균을 구하세요.
SELECT * FROM PRODUCTS
WHERE OUTPUT_PRICE >= 
( SELECT AVG(OUTPUT_PRICE) FROM PRODUCTS 
WHERE OUTPUT_PRICE <> ( SELECT MAX(OUTPUT_PRICE)FROM PRODUCTS) );

87] 상품 카테고리 테이블에서 카테고리 이름에 컴퓨터라는 단어가 포함된 카테고리에
	    속하는 상품 목록을 보여주세요.

select * from products
    where category_fk IN (select category_code from category where category_name LIKE '%컴퓨터%');
88] 고객 테이블에 있는 고객정보 중 직업의 종류별로 가장 나이가 많은 사람의 정보를
    화면에 보여주세요.
    SELECT * FROM MEMBER
    WHERE (JOB, AGE) IN
    (SELECT JOB, MAX(AGE) FROM MEMBER
    GROUP BY JOB);

	--* UPDATE에서의 사용
    -- UPDATE 테이블명 SET 컬럼명=값,... WHERE 조건

	89] 고객 테이블에 있는 고객 정보 중 마일리지가 가장 높은 금액을
	     가지는 고객에게 보너스 마일리지 5000점을 더 주는 SQL을 작성하세요.
	update member set mileage =	mileage + 5000 where mileage = (select max(mileage)
                                                             from member);
    SELECT * FROM MEMBER;
    ROLLBACK;

	90] 고객 테이블에서 마일리지가 없는 고객의 등록일자를 고객 테이블의 
	      등록일자 중 가장 뒤에 등록한 날짜에 속하는 값으로 수정하세요.	 
    UPDATE MEMBER SET REG_DATE = ( SELECT MAX(REG_DATE) FROM MEMBER)
    WHERE MILEAGE =0;
    
    	* DELETE에서의 사용
        DELETE FROM 테이블명 WHERE 조건절;
        
	91] 상품 테이블에 있는 상품 정보 중 공급가가 가장 큰 상품은 삭제 시키는 
	      SQL문을 작성하세요.
	      delete from products where input_price = (select max(input_price) from products);
            select * from products;
            rollback;

	92] 상품 테이블에서 상품 목록을 공급 업체별로 정리한 뒤,
	     각 공급업체별로 최소 판매 가격을 가진 상품을 삭제하세요.
         delete from products where (ep_code_fk,output_price) in(
            select ep_code_fk,min(output_price) from products
            group by ep_code_fk);
            
        select * from products;
        rollback;
        
# INSERT에서 SUBQUERY 사용        
CATEGORY테이블을 카피해서 CATEGORY_COPY로 만들되 데이터는 없이 구조만 복사하세요
그런뒤 CATEGORY 테이블에서 전자제품군만 가져와서 CATEGORY_COPY에 INSERT하세요

DROP TABLE CATEGORY_COPY;
         
CREATE TABLE CATEGORY_COPY
AS
SELECT * FROM CATEGORY WHERE 1=2;

SELECT * FROM CATEGORY_COPY;

INSERT INTO CATEGORY_COPY
SELECT * FROM CATEGORY
WHERE CATEGORY_CODE LIKE '0001%';
        
         
EMP에서 EMP_COPY 테이블로 구조만 복사하기         
급여등급이 3등급에 속하는 사원정보들만 EMP_COPY에 INSERT하세요

CREATE TABLE EMP_COPY
AS
SELECT * FROM EMP WHERE 1=2;

SELECT * FROM EMP_COPY;

INSERT INTO EMP_COPY
SELECT E.* FROM EMP E JOIN SALGRADE S
ON  E.SAL BETWEEN S.LOSAL AND S.HISAL AND S.GRADE=3;

COMMIT;

# FROM 절에서의 서브쿼리 ===> INLINE VIEW

EMP와 DEPT 테이블에서 업무가 MANAGER인 사원의 이름, 업무,부서명,
근무지를 출력하세요.

SELECT ENAME, JOB, DNAME, LOC
FROM EMP E JOIN DEPT D
USING(DEPTNO)
WHERE JOB='MANAGER';

SUBQUERY 로 동일한 문제를 풀어보자

SELECT A.ENAME, JOB, DNAME, LOC FROM 
(SELECT * FROM EMP WHERE JOB='MANAGER') A JOIN DEPT D
ON A.DEPTNO = D.DEPTNO;


RANK() OVER() 함수 : 랭킹을 매겨주는 함수

SELECT ENAME, SAL FROM EMP
ORDER BY SAL DESC;

# RANK() OVER() : 분석절을 기준으로 랭킹을 매기는 함수
SELECT * FROM (
SELECT RANK() OVER( ORDER BY SAL DESC ) RNK, EMP.* FROM EMP
)
WHERE RNK <=5;

# ROW_NUMBER() OVER() : 행번호를 매겨주는 함수
SELECT * FROM(
SELECT ROWNUM RN, A.* FROM
(SELECT * FROM EMP ORDER BY HIREDATE DESC) A
)
WHERE RN <=5;

SELECT * FROM(
SELECT ROW_NUMBER() OVER(ORDER BY HIREDATE DESC) RN, EMP.*
FROM EMP) WHERE RN <=5;

select * from memo;
desc memo;
drop table memo;

create sequence memo_seq






         
         
         
         
         