-- day07_plsql.sql
--# IN OUT PARAMETER
--프로시저가 읽고 쓰는 작업을 동시에 할 수 있는 파라미터
CREATE OR REPLACE PROCEDURE INOUT_TEST(
    A1 IN NUMBER,
    A2 IN VARCHAR2,
    A3 IN OUT VARCHAR2,
    A4 OUT VARCHAR2
)
IS
    MSG VARCHAR2(30) :='';
BEGIN
    DBMS_OUTPUT.PUT_LINE('-------------------');
    DBMS_OUTPUT.PUT_LINE('프로시저 시작 전');
    DBMS_OUTPUT.PUT_LINE('------------------');
    DBMS_OUTPUT.PUT_LINE('A1: '||A1);
    DBMS_OUTPUT.PUT_LINE('A2: '||A2);
    DBMS_OUTPUT.PUT_LINE('A3: '||A3);
    DBMS_OUTPUT.PUT_LINE('A4: '||A4);
    A3 :='프로시저 외부에서 이 값을 받을 수 있을까요?';
    MSG :='SUCCESS';
    A4 :=MSG;
    DBMS_OUTPUT.PUT_LINE('-------------------');
    DBMS_OUTPUT.PUT_LINE('프로시저 시작 후');
    DBMS_OUTPUT.PUT_LINE('------------------');
    DBMS_OUTPUT.PUT_LINE('A1: '||A1);
    DBMS_OUTPUT.PUT_LINE('A2: '||A2);
    DBMS_OUTPUT.PUT_LINE('A3: '||A3);
    DBMS_OUTPUT.PUT_LINE('A4: '||A4);
END;
/

VARIABLE C VARCHAR2(100);
VARIABLE D VARCHAR2(100);

EXEC INOUT_TEST(5000,'안녕',:C, :D);

PRINT D
PRINT C
SET SERVEROUTPUT ON
# 제어문
IF  THEN
ELSIF THEN
...
ELSE
END IF;
/*
사번을 인파라미터로 전달하면 사원의 부서번호에 따라 소속된 부서명을
문자열로 출력하는 프로시저
10 회계부서
20 연구부서
30 영업부서
40 운영부서
*/
CREATE OR REPLACE PROCEDURE DEPT_FIND(PNO IN EMP.EMPNO%TYPE)
IS
VDNO EMP.DEPTNO%TYPE;
VENAME EMP.ENAME%TYPE;
VDNAME VARCHAR2(20);
BEGIN
    SELECT ENAME, DEPTNO INTO VENAME, VDNO
    FROM EMP
    WHERE EMPNO = PNO;
    IF VDNO=10 THEN VDNAME:='회계부서';
    ELSIF VDNO=20 THEN VDNAME :='연구부서';
    ELSIF VDNO=30 THEN VDNAME :='영업부서';
    ELSIF VDNO=40 THEN VDNAME :='운영부서';
    ELSE VDNAME:='아직 부서 배정 못받음';
    END IF;
    DBMS_OUTPUT.PUT_LINE(VENAME||'님은 '||VDNO||'번 '||VDNAME||'에 있습니다');
END;
/
EXEC DEPT_FIND(7788);
--
--사원명을 인파라미터로 전달하면
--해당 사원의 연봉을 계산해서 출력하는 프로시저를 작성하되,
--연봉은 COMM이 NULL인 경우와 NULL아 아닌경우를 나눠서 계산하세요
--출력문
--사원명  월급여  보너스 연봉 
--출력하세요
CREATE OR REPLACE PROCEDURE EMP_SAL(
PNAME IN EMP.ENAME%TYPE)
IS
VSAL EMP.SAL%TYPE;
VCOMM EMP.COMM%TYPE;
TOTAL NUMBER(8);
BEGIN
    SELECT SAL, COMM INTO VSAL, VCOMM
    FROM EMP WHERE ENAME=UPPER(PNAME);
    IF VCOMM IS NULL THEN
        TOTAL := VSAL*12;
    ELSE 
        TOTAL := VSAL*12+VCOMM;
    END IF;
    DBMS_OUTPUT.PUT_LINE(PNAME||'------');
    DBMS_OUTPUT.PUT_LINE('월급여: '||VSAL);
    DBMS_OUTPUT.PUT_LINE('보너스: '||VCOMM);
    DBMS_OUTPUT.PUT_LINE('연 봉: '||TOTAL);  
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(PNAME||'님은 없습니다');
    WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE(PNAME||'님 데이터가 2건 이상입니다');
END;
/

EXEC EMP_SAL('SCOTT');
EXEC EMP_SAL('MARTIN');
EXEC EMP_SAL('TOM');

SET SERVEROUTPUT ON
SELECT * FROM EMP;
INSERT INTO EMP(EMPNO,ENAME,SAL,COMM)
VALUES(8002,'TOM',2000,3000);
COMMIT;


--# FOR LOOP문
--FOR I IN 시작값 .. 종료값 LOOP
--    실행문
--END LOOP;

DECLARE
VSUM NUMBER(4) :=0;
BEGIN
    -- 1부터 10까지의 합
    FOR I IN REVERSE 1 .. 10 LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        VSUM:= VSUM+I;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('까지의 합:'||VSUM);
END;
/

--JOB을 인파라미터로 전달하면 해당 업무를 수행하는 사원들의 정보
--사번, 사원명, 부서번호, 부서명, 업무를 출력하세요
--FOR LOOP를 이용해서 풀되 서브쿼리를 이용하세요
CREATE OR REPLACE PROCEDURE EMP_JOB(
PJOB IN EMP.JOB%TYPE)
IS
BEGIN
    FOR E IN (SELECT EMPNO, ENAME, DEPTNO, JOB, 
                (SELECT DNAME FROM DEPT WHERE DEPTNO =EMP.DEPTNO) DNAME
                FROM EMP
                WHERE JOB=PJOB) LOOP
        DBMS_OUTPUT.PUT_LINE(E.EMPNO||LPAD(E.ENAME,10,' ')||
        LPAD(E.DEPTNO,8,' ')||LPAD(E.JOB,12,' ')||LPAD(E.DNAME,16,' '));    
    END LOOP;
END;
/
EXEC EMP_JOB('ANALYST');

SELECT EMPNO, ENAME, DEPTNO, JOB, 
(SELECT DNAME FROM DEPT WHERE DEPTNO =EMP.DEPTNO) DNAME
FROM EMP
WHERE JOB='MANAGER';


--1~100까지의 숫자 중 짝수만 출력하기
-- EXIT WHEN 조건;
-- CONTINUE WHEN 조건;
DECLARE
BEGIN
    FOR K IN 1 .. 100 LOOP
        CONTINUE WHEN MOD(K, 2)=1;
        DBMS_OUTPUT.PUT_LINE(K);
    END LOOP;
END;
/

--# LOOP 문
--LOOP
--	실행문장;
--EXIT [WHEN 조건문]
--END LOOP;

--EMP테이블에 사원정보를 등록하되 LOOP문 이용해서 등록해봅시다.
--'NONAME1'

DECLARE
VCNT NUMBER(3) := 100;
BEGIN
    LOOP
        INSERT INTO EMP(EMPNO, ENAME,HIREDATE)
        VALUES(VCNT+8100,'NONAME'||VCNT, SYSDATE);
    VCNT := VCNT+1;
    EXIT WHEN VCNT >105;    
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(VCNT-100||'건의 데이터 입력 완료');
END;
/
SELECT * FROM EMP;
ROLLBACK;

# WHILE LOOP문
--WHILE 조건 LOOP
--    실행문
--    EXIT WHEN 조건;
--END LOOP;

DECLARE
VCNT NUMBER(3) :=0;
BEGIN
    WHILE VCNT <10 LOOP
        VCNT := VCNT+2;         
        EXIT WHEN VCNT=4;
        DBMS_OUTPUT.PUT_LINE(VCNT);        
    END LOOP;
END;
/

--# CASE문
--CASE 비교기준
--    WHEN 값1 THEN 실행문;
--    WHEN 값2 THEN 실행문;
--    ...
--    ELSE
--    실행문
--END CASE;
CREATE OR REPLACE PROCEDURE GRADE_AVG(SCORE IN NUMBER)
IS
HAK CHAR(1) :='F';
BEGIN
    CASE 
    WHEN SCORE >=90 THEN HAK:='A';
    WHEN SCORE >=80 THEN HAK:='B';
    WHEN SCORE >=70 THEN HAK:='C';
    WHEN SCORE >=60 THEN HAK:='D';
    ELSE HAK:='F';
    END CASE;    
    DBMS_OUTPUT.PUT_LINE(SCORE||'점 '||HAK||'학점');    
END;
/
EXEC GRADE_AVG(100);

--평균점수를 인파라미터로 전달하면
--학점을 출력하는 프로시저를 작성하세요
--프로시저명: GRADE_AVG
--100~90 : A
--81 => B
--77 => C
--60점대 => D
--나머지 => F

CREATE OR REPLACE PROCEDURE GRADE_AVG2 (SCORE IN NUMBER)
IS
BEGIN
    CASE FLOOR(SCORE/10)
        WHEN 10 THEN DBMS_OUTPUT.PUT_LINE('A');
        WHEN 9 THEN DBMS_OUTPUT.PUT_LINE('A');
        WHEN 8 THEN DBMS_OUTPUT.PUT_LINE('B');
        WHEN 7 THEN DBMS_OUTPUT.PUT_LINE('C');
        WHEN 6 THEN DBMS_OUTPUT.PUT_LINE('D');
        ELSE 
        DBMS_OUTPUT.PUT_LINE('F');
    END CASE;
END;
/
EXEC GRADE_AVG2(50);

# 암시적 커서

CREATE OR REPLACE PROCEDURE IMPLICIT_CURSOR
(PNO IN EMP.EMPNO%TYPE)
IS
VSAL EMP.SAL%TYPE;
UPDATE_ROW NUMBER;
BEGIN
    SELECT SAL INTO VSAL
    FROM EMP WHERE EMPNO =PNO;
    -- 검색된 데이터가 있다면
    IF SQL%FOUND THEN -- 암시적 커서의 속성을 이용
        DBMS_OUTPUT.PUT_LINE(PNO||'번 사원의 월급여는 '||VSAL||'입니다. 10% 인상예정입니다');
    END IF;
    UPDATE EMP SET SAL=SAL*1.1 WHERE EMPNO=PNO;
    UPDATE_ROW:= SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE(UPDATE_ROW||'명의 사원이 급여가 인상되었어요');
    SELECT SAL INTO VSAL
    FROM EMP WHERE EMPNO =PNO;
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE(PNO||'번 사원의 인상된 월급여는 '||VSAL||'입니다.');
    END IF;
END;
/

EXEC IMPLICIT_CURSOR(7788);
ROLLBACK;

/*# 명시적 커서
- 커서 선언
- 커서 OPEN
- 반복문 돌면서
   커서에서 FETCH한다
- 커서 CLOSE
*/
CREATE OR REPLACE PROCEDURE EMP_ALL
IS
VNO EMP.EMPNO%TYPE;
VNAME EMP.ENAME%TYPE;
VDATE EMP.HIREDATE%TYPE;
-- 커서 선언
CURSOR EMP_CR IS
    SELECT EMPNO, ENAME, HIREDATE
    FROM  EMP ORDER BY 1 ASC;
BEGIN
-- 커서 오픈
OPEN EMP_CR;
LOOP
    FETCH EMP_CR INTO
    VNO, VNAME, VDATE;
EXIT WHEN EMP_CR%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(VNO||LPAD(VNAME,12,' ')||LPAD(VDATE,12,' '));
END LOOP;    
-- 커서 닫기
CLOSE EMP_CR;
END;
/

EXECUTE EMP_ALL;

--[실습] 부서별 사원수, 평균급여, 최대급여, 최소급여를 가져와 출력하는
--      프로시저를 작성하세요.
      
SELECT DEPTNO, COUNT(EMPNO) CNT, AVG(SAL) AVG_SAL, MAX(SAL) MAX_SAL, MIN(SAL) MIN_SAL
FROM EMP
GROUP BY DEPTNO
HAVING DEPTNO IS NOT NULL
ORDER BY 1;

CREATE OR REPLACE PROCEDURE DEPT_STAT
IS
VDNO EMP.DEPTNO%TYPE;
VCNT NUMBER;
VAVG NUMBER;
VMAX NUMBER;
VMIN NUMBER;
-- 커서 선언
CURSOR CR IS
SELECT DEPTNO, COUNT(EMPNO) CNT, AVG(SAL) AVG_SAL, MAX(SAL) MAX_SAL, MIN(SAL) MIN_SAL
FROM EMP
GROUP BY DEPTNO
HAVING DEPTNO IS NOT NULL
ORDER BY 1;
BEGIN
-- FOR 루프에서 커서를 이용하면 별도로 OPEN,FETCH,CLOSE할 필요가 없음
-- 자동으로 관리함
    FOR K IN CR LOOP
        DBMS_OUTPUT.PUT_LINE(K.DEPTNO||LPAD(K.CNT,10,' ')||LPAD(K.AVG_SAL,10,' ')||
        LPAD(K.MAX_SAL,10,' ')||LPAD(K.MIN_SAL,10,' '));
    END LOOP;
END;
/
EXEC DEPT_STAT;
--# SUBQUERY
--
--부서테이블의 모든 정보를 가져와 출력하는 프로시저를 작성하되
--FOR LOOP이용하기

CREATE OR REPLACE PROCEDURE DEPT_ALL
IS
BEGIN
    FOR K IN (SELECT * FROM DEPT ORDER BY DEPTNO) LOOP
        DBMS_OUTPUT.PUT_LINE(K.DEPTNO||LPAD(K.DNAME,12,' ')||LPAD(K.LOC,12,' '));
    END LOOP;
END;
/
EXEC DEPT_ALL;

# 미리 정의된 예외 처리하기
SELECT * FROM MEMBER;
--MEMBER 테이블의 USERID 컬럼에 UNIQUE 제약조건을 추가하되 제약조건 이름 주어 추가하세요
ALTER TABLE MEMBER ADD CONSTRAINT MEMBER_USERID_UK UNIQUE(USERID);

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='MEMBER';

CREATE SEQUENCE MEMBER_SEQ
START WITH 11
INCREMENT BY 1
NOCACHE;

--MEMBER테이블에 새로운 레코드를 추가하는 프로시저를 작성하되
--인파라미터로 회원명, 아이디, 비밀번호, 나이, 직업, 주소
--를 주고 해당 데이터를 INSERT하는 프로시저를 작성하세요

CREATE OR REPLACE PROCEDURE MEMBER_ADD(
PNAME IN MEMBER.NAME%TYPE,
PID IN MEMBER.USERID%TYPE,
PWD IN MEMBER.PASSWD%TYPE,
PAGE IN NUMBER,
PJOB IN MEMBER.JOB%TYPE,
PADDR IN MEMBER.ADDR%TYPE)
IS
VNAME MEMBER.NAME%TYPE;
VUID MEMBER.USERID%TYPE;
BEGIN
    INSERT INTO MEMBER(NUM,USERID,NAME,PASSWD,AGE,JOB,ADDR,REG_DATE)
    VALUES(MEMBER_SEQ.NEXTVAL,PID,PNAME, PWD,PAGE, PJOB, PADDR, SYSDATE);
    IF SQL%ROWCOUNT>0 THEN
        DBMS_OUTPUT.PUT_LINE('회원가입 완료');
    END IF;
    SELECT NAME, USERID INTO VNAME, VUID
    FROM MEMBER WHERE NAME=PNAME;
    DBMS_OUTPUT.PUT_LINE(PNAME||'님 '||VUID||'아이디로 등록되었습니다');
    -- DBMS_OUTPUT.PUT_LINE(10/0);
    EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('등록하려는 아이디는 이미 등록되어있어요');
    WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE(PNAME||'님 데이터는 2건 이상 있습니다');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('기타 예상치 못했던 예외 발생: '||SQLERRM||SQLCODE);
END;
/
EXEC MEMBER_ADD('최유나','CHOI','123',23,'학생','서울 강남구');

SELECT * FROM MEMBER ORDER BY REG_DATE DESC;

# 사용자 정의 예외 만들고 발생시키기

SELECT COUNT(*) FROM EMP
GROUP BY DEPTNO;

--부서 인원이 5명 미만이면 사용자정의 예외를 만들어 발생시키자

CREATE OR REPLACE PROCEDURE USER_EXCEPT
(PDNO IN DEPT.DEPTNO%TYPE)
IS
--1. 예외 선언
    MY_DEFINE_ERROR EXCEPTION;
    VCNT NUMBER;
BEGIN
    SELECT COUNT(EMPNO) INTO VCNT
    FROM EMP WHERE DEPTNO = PDNO;
    --2. 예외 발생시키기=> RAISE문을 이용
    IF VCNT <5 THEN
        RAISE MY_DEFINE_ERROR;
    END IF;
    DBMS_OUTPUT.PUT_LINE(PDNO||'번 부서 인원은 '||VCNT||'명 입니다');
    -- 3. 예외 처리 단계
    EXCEPTION
        WHEN MY_DEFINE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20001,'부서 인원이 5명 미만인 부서는 안돼요');
END;
/

EXEC USER_EXCEPT(40);

# FUNCTION
 - 실행환경에 반드시 하나의 값을 RETURN해야 한다.
  
--사원명을 입력하면 해당 사원이 소속된 부서명을 반환하는 함수를 작성하세요
CREATE OR REPLACE FUNCTION GET_DNAME(
PNAME IN EMP.ENAME%TYPE)
-- 반환해줄 데이터 유형을 지정
RETURN VARCHAR2
IS
VDNO EMP.DEPTNO%TYPE;
VDNAME DEPT.DNAME%TYPE;
BEGIN
    SELECT DEPTNO INTO VDNO FROM EMP
    WHERE ENAME=PNAME;
    SELECT DNAME INTO VDNAME FROM DEPT
    WHERE DEPTNO = VDNO;
    RETURN VDNAME; -- 값을 반환한다    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE(PNAME||'사원은 없습니다');
    RETURN SQLERRM;
    WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE(PNAME||'사원 데이터가 2건 이상입니다');
    RETURN SQLERRM;
END;
/
VAR GNAME VARCHAR2;
EXEC :GNAME := GET_DNAME('KING')
PRINT GNAME















