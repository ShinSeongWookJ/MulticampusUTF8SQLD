--day06_plsql.sql
/*
[1] 프로시저 익명블럭
- 선언부
- 실행부
- 예외처리부
*/
DECLARE
  -- 선언부에서는 변수 선언을 할 수 있다.
  I_MSG VARCHAR2(100);
BEGIN
  -- 실행부에는 SQL 또는 PL/SQL문이 올 수 있다.
  I_MSG := 'HELLO ORACLE';
  DBMS_OUTPUT.PUT_LINE(I_MSG);
END;
/

SET SERVEROUTPUT ON


--[2] 이름을 갖는 프로시저

CREATE OR REPLACE PROCEDURE PRINT_TIME
IS
-- 선언부
    VTIME1 TIMESTAMP;
    VTIME2 TIMESTAMP;     
BEGIN
-- 실행부 날짜 + 숫자 : 일수를 더함, 날짜 +숫자/24 : 시간을 더함
    SELECT SYSTIMESTAMP - 1/24 INTO VTIME1 FROM DUAL;
    SELECT SYSTIMESTAMP + 2/24 INTO VTIME2 FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('한 시간 전: '||VTIME1);
    DBMS_OUTPUT.PUT_LINE('두 시간 후: '||VTIME2);
END;
/

SET SERVEROUTPUT ON

-- 프로시저 실행방법
EXECUTE PRINT_TIME;


--사번을 인 파라미터로 전달하면 해당 사원의
--사번, 이름, 부서명, 담당업무를 가져와
--출력하는 프로시저를 작성해봅시다.

CREATE OR REPLACE PROCEDURE EMP_INFO(PNO IN NUMBER)
IS
VNO NUMBER(4); -- 스칼라타입
VNAME EMP.ENAME%TYPE; -- EMP테이블의 ENAME컬럼과 같은 자료유형으로 하겠다는 의미
VDNAME DEPT.DNAME%TYPE;
VJOB EMP.JOB%TYPE;
VDNO EMP.DEPTNO%TYPE;
BEGIN
-- SELECT INTO로 가져온 데이터 변수에 할당하기
SELECT ENAME, JOB, DEPTNO INTO VNAME, VJOB, VDNO
FROM EMP WHERE EMPNO=PNO;
SELECT DNAME INTO VDNAME FROM DEPT
WHERE DEPTNO=VDNO;
-- DBMS로 출력하기
DBMS_OUTPUT.PUT_LINE('----'||PNO||'번 사원정보----');
DBMS_OUTPUT.PUT_LINE('사 원 명: '||VNAME);
DBMS_OUTPUT.PUT_LINE('담당업무: '||VJOB);
DBMS_OUTPUT.PUT_LINE('부 서 명: '||VDNAME);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(PNO||'번 사원은 존재하지 않아요');
END;
/

EXECUTE EMP_INFO(8499);

%TYPE : REFERENCE 타입. 테이블명.컬럼명%TYPE

%ROWTYPE : COMPOSITE 타입  테이블명%ROWTYPE : 테이블의 행과 같은 타입

부서번호를 인파라미터로 주면
해당 부서의 부서명과 근무지를 출력하는 프로시저를 작성합시다

CREATE OR REPLACE PROCEDURE RTYPE(PDNO IN DEPT.DEPTNO%TYPE)
IS
VDEPT DEPT%ROWTYPE;
BEGIN
SELECT DNAME, LOC INTO VDEPT.DNAME, VDEPT.LOC 
FROM DEPT WHERE DEPTNO=PDNO;

DBMS_OUTPUT.PUT_LINE('부서번호: '||PDNO);
DBMS_OUTPUT.PUT_LINE('부 서 명 :'||VDEPT.DNAME);
DBMS_OUTPUT.PUT_LINE('부서위치: '||VDEPT.LOC);
-- 예외처리하기
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(PDNO||'번 부서 정보는 없습니다.');
END;
/
EXECUTE RTYPE(50);
----------------------------------------------------------
--# TABLE TYPE : COMPOSITE TYPE (복합데이터 타입) => 배열과 비슷함
--TABLE타입에 접근하기 위한 인덱스가 있는데 BINARY_INTEGER 데이터 형의 인덱스
--를 이용할 수 있다.

--
--TYPE table_type_name IS TABLE OF
--	{column_type | variable%TYPE| table.column%TYPE} [NOT NULL]
--	[INDEX BY BINARY_INTEGER];
--	identifier table_type_name;
사원들의 업무 정보를 담을 테이블 타입의 변수를 선언하고
사원들의 업무 정보를 저장하기
반복문 이용해서 이름과 업무 정보 출력하기

CREATE OR REPLACE PROCEDURE TABLE_TYPE(PDNO IN EMP.DEPTNO%TYPE)
IS
-- 테이블 선언
    TYPE ENAME_TABLE IS TABLE OF EMP.ENAME%TYPE
    INDEX BY BINARY_INTEGER;   
    TYPE JOB_TABLE IS TABLE OF EMP.JOB%TYPE
    INDEX BY BINARY_INTEGER;    
-- 테이블 타입의 변수 선언    
    ENAME_TAB ENAME_TABLE;
    I BINARY_INTEGER :=0;    
    JOB_TAB JOB_TABLE;    
BEGIN
    FOR K IN (SELECT ENAME, JOB FROM EMP WHERE DEPTNO=PDNO) LOOP
    I:= I+1;
    -- 테이블 변수에 가져온 값들을 저장하자.
        ENAME_TAB(I) :=K.ENAME;
        JOB_TAB(I) :=K.JOB;
    END LOOP;
    -- 테이블 타입에 저장된 값을 출력하자.
     FOR J IN 1..I LOOP
        DBMS_OUTPUT.PUT_LINE(ENAME_TAB(J)||': '||JOB_TAB(J));
     END LOOP;
END;
/
EXECUTE TABLE_TYPE(20);


# RECORD TYPE

--상품번호를 입력하면 해당상품의 상품명, 판매가, 제조사를 출력하는 프로시저를 작성하세요 

ACCEPT PNUM PROMPT '조회할 상품번호를 입력하세요'
-- PNUM을 사용할 때는 '&PNUM'
DECLARE
    TYPE PROD_RECORD_TYPE IS RECORD(
        VPNAME PRODUCTS.PRODUCTS_NAME%TYPE,
        VPRICE PRODUCTS.OUTPUT_PRICE%TYPE,
        VCOMP PRODUCTS.COMPANY%TYPE
    );
    -- 레코드 타입의 변수선언
    PROD_REC PROD_RECORD_TYPE;
    VPNUM NUMBER :='&PNUM';
BEGIN
    SELECT PRODUCTS_NAME, OUTPUT_PRICE, COMPANY
    INTO PROD_REC
    FROM PRODUCTS
    WHERE PNUM=VPNUM;
    DBMS_OUTPUT.PUT_LINE(&PNUM||'번 상품 정보-------');
    DBMS_OUTPUT.PUT_LINE('상품명: '||PROD_REC.VPNAME);
    DBMS_OUTPUT.PUT_LINE('제조사: '||PROD_REC.VCOMP);
    DBMS_OUTPUT.PUT_LINE('가  격: '||LTRIM(TO_CHAR(PROD_REC.VPRICE,'999,999,999'))||'원');
END;
/

--바인드 변수 - NON-PL/SQL 변수
VARIABLE MYVAR NUMBER
--프로시저 내부에서 바인드 변수를 참조하려면
--바인드변수 앞에 콜론(:)을 참조 접두어로 기술한다.
DECLARE
BEGIN
:MYVAR :=700;
END;
/

PRINT MYVAR

--# 프로시저 파라미터 종류
--[1] IN 파라미터
--[2] OUT 파라미터
--[3] IN OUT 파라미터

--MEMO테이블에 새로운 레코드를 INSERT하는 프로시저를 작성하세요
--작성자와, 메모내용은 IN 파라미터로 받습니다.
프로시저명: MEMO_ADD

CREATE OR REPLACE PROCEDURE MEMO_ADD(
PNAME IN VARCHAR2 DEFAULT '아무개',
PMSG IN MEMO.MSG%TYPE)
IS
BEGIN
    INSERT INTO MEMO(IDX,NAME,MSG,WDATE)
    VALUES(MEMO_SEQ.NEXTVAL,PNAME, PMSG, SYSDATE);
    COMMIT;
END;
/

EXEC MEMO_ADD('홍길동','프로시저로 글을 씁니다');
EXEC MEMO_ADD(PMSG=>'안녕');
SELECT * FROM MEMO ORDER BY IDX DESC;

# OUT 파라미터: 프로시저가 사용자에게 넘겨주는 값
    [주의] 디폴트값을 정할 수 없다
    
사번을 인 파라미터로 전달하면 해당 사원의 이름을 아웃 파라미터로
내보내는 프로시저를 작성하세요
=> OUT 파라미터를 받으려면 바인드변수가 필요함

CREATE OR REPLACE PROCEDURE EMP_FIND(
PNO IN EMP.EMPNO%TYPE,
ONAME OUT EMP.ENAME%TYPE)
IS
BEGIN
    SELECT ENAME INTO ONAME
    FROM EMP
    WHERE EMPNO = PNO;
END;
/
실행방법
바인드 변수 선언
프로시저를 실행할때 바인드변수를 아웃파라미터의 매개변수로 전달한다
바인드변수값을 출력

VAR GNAME VARCHAR2(20);
EXEC EMP_FIND(7788, :GNAME);

PRINT GNAME;

--부서번호를 인파라미터로 받고, 급연 인상률도 인파라미터로 받아서
--EMP테이블의 특정 부서 직원들의 급여를 인상해주고
--그런뒤 해당 부서의 평균급여를 아웃파라미터로 전달하는 프로시저를
--작성한 뒤
--해당 부서의 평균급여를 출력하세요
create or replace procedure sal_up
(dno in dept.deptno%type, upsal in number, avgsal out number)
is
begin
    update emp set sal = sal * upsal where deptno = dno;
    
    select avg(sal) into avgsal
    from emp
    group by deptno
    having deptno = dno;
end;
/

SELECT AVG(SAL) FROM EMP
WHERE DEPTNO=10;
--2587.5  2846.25

VAR AVGSAL NUMBER;

EXEC sal_up(10, 1.1, :AVGSAL)

PRINT AVGSAL;

SELECT ENAME,SAL FROM EMP WHERE DEPTNO=10;

ROLLBACK;

MEMO_EDIT 프로시저를 작성하세요
인파라미터 3개 받아서(글번호, 작성자, 메시지)
UPDATE문을 수행하는 프로시저




















`












