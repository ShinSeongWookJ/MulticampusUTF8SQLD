create table [스키마.]테이블명(
   컬럼명 자료형 default 기본값  constraint 제약조건이름 제약조건유형,
   ...
);
# PRIMARY KEY
-- 컬럼수준에서 제약하기
CREATE TABLE TEST_TAB1(
    NO NUMBER(2) CONSTRAINT TEST_TAB1_NO_PK PRIMARY KEY,
    NAME VARCHAR2(20)
);

DESC TEST_TAB1;

데이터사전에서 조회

SELECT *
FROM USER_CONSTRAINTS WHERE TABLE_NAME='TEST_TAB1';


INSERT INTO TEST_TAB1(NO,NAME)
VALUES(2,NULL);

SELECT * FROM TEST_TAB1;
COMMIT;

-- 테이블 수준에서 PK제약
CREATE TABLE TEST_TAB2(
    NO NUMBER(2),
    NAME VARCHAR2(20),
    CONSTRAINT TEST_TAB2_NO_PK PRIMARY KEY (NO)
);
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME='TEST_TAB2';

# 제약조건 삭제
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명 [CASCADE];
 - CASCADE 를 주면 모든 종속적인 제약조건이 함께 삭제된다.
 
TEST_TAB2의 pk제약조건을 삭제하세요
ALTER TABLE TEST_TAB2 DROP CONSTRAINT TEST_TAB2_NO_PK;

#제약조건 추가
ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 제약조건유형 (컬럼명)

TEST_TAB2에 다시 pk제약조건을 추가하세요

ALTER TABLE TEST_TAB2 ADD CONSTRAINT TEST_TAB2_PK PRIMARY KEY (NO);

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME='TEST_TAB2';

DESC TEMP;





# 제약조건명 변경
ALTER TABLE 테이블명 RENAME CONSTRAINT OLD명 TO NEW명;
ALTER TABLE TEST_TAB2 RENAME CONSTRAINT TEST_TAB2_PK TO TEST_TAB2_NO_PK;

# Foreign Key 제약조건
부모 테이블(MASTER)의 PK를 자식테이블(DETAIL)에서 FK로 참조
==> FK는 DETAIL테이블에서 정의해야 함
MASTER 테이블의 PK, UK 로 정의된 컬럼을 FK로 지정할 수 있다.
컬럼의 자료형이 일치해야 한다. 크기는 일치하지 않아도 상관없음
ON DELETE CASCADE 옵션을 주면 MASTER 테이블의 레코드가 삭제될 때
DETAIL 테이블의 레코드도 같이 삭제된다.

CREATE TABLE DEPT_TAB(
    DEPTNO NUMBER(2),
    DNAME VARCHAR2(15),
    LOC VARCHAR2(15),
    CONSTRAINT DEPT_TAB_DEPTNO_PK PRIMARY KEY (DEPTNO)
);
CREATE TABLE EMP_TAB(
    EMPNO NUMBER(4),
    ENAME VARCHAR2(20),
    JOB VARCHAR2(10),
    MGR  NUMBER(4) CONSTRAINT EMP_TAB_MGR_FK REFERENCES EMP_TAB(EMPNO),
    HIREDATE DATE,
    SAL NUMBER(7,2),
    COMM NUMBER(7,2),
    DEPTNO NUMBER(2),
    -- 테이블 수준에서 FK주기
    CONSTRAINT EMP_TAB_DEPTNO_FK FOREIGN KEY (DEPTNO)
    REFERENCES DEPT_TAB (DEPTNO),
    CONSTRAINT EMP_TAB_EMPNO_PK PRIMARY KEY (EMPNO)
);

부서정보 INSERT하기
10 기획부 서울
20 인사부 인천

INSERT INTO DEPT_TAB VALUES(10,'기획부','서울');
INSERT INTO DEPT_TAB VALUES(20,'인사부','인천');
COMMIT;

SELECT * FROM DEPT_TAB;

사원정보 INSERT하기
INSERT INTO EMP_TAB(EMPNO,ENAME,JOB,MGR,DEPTNO)
VALUES(1000,'홍길동','기획',NULL, 10);

INSERT INTO EMP_TAB(EMPNO,ENAME,JOB,MGR,DEPTNO)
VALUES(1002,'이영희','인사',NULL, 20);

SELECT * FROM EMP_TAB;
COMMIT;

INSERT INTO EMP_TAB(EMPNO,ENAME,JOB,MGR,DEPTNO)
VALUES(1003,'김순희','노무',1002, 20);
INSERT INTO EMP_TAB(EMPNO,ENAME,JOB,MGR,DEPTNO)
VALUES(1004,'김길동','재무',1001, 20);

DEPT_TAB에서 기획부를 삭제해보기
DELETE FROM DEPT_TAB WHERE DEPTNO=10;
==> 자식 레코드가 있을 경우는 부모 테이블의 레코드를 삭제할 수 없다.

홍길동을 20번부서로 부서이동 하세요
UPDATE EMP_TAB SET DEPTNO=20 WHERE ENAME='홍길동';

SELECT * FROM EMP_TAB;
DELETE FROM DEPT_TAB WHERE DEPTNO=10;
SELECT * FROM DEPT_TAB;


부모테이블
BOARD_TAB
NO NUMBER(8)  PK
USERID VARCHAR2(20) NOT NULL,
TITLE VARCHAR2(100),
CONTENT VARCHAR2(1000)
WDATE DATE 기본값 SYSDATE

자식테이블
REPLY_TAB
RNO NUMBER(8) PK
CONTENT VARCHAR2(300)
USERID VARCHAR2(20) not null,
NO_FK NUMBER(8)==> FK로 주되 ON DELETE CASCADE 옵션을 기술하기

create table board_tab(
    no number(8) primary key,
    userid varchar2(20) not null,
    title varchar2(100),
    content varchar2(1000),
    wdate date default sysdate
);
create table reply_tab(
    rno number(8) primary key,
    content varchar2(300),
    userid varchar2(20) not null,
    no_fk number(8) references board_tab(no) on delete cascade
);

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='REPLY_TAB';

INSERT INTO BOARD_TAB VALUES(2,'CHOI','저도 반가워요','안녕2',SYSDATE);
COMMIT;

SELECT * FROM BOARD_TAB;
댓글달기
INSERT INTO REPLY_TAB VALUES(3,'안녕???','KIM',1);

COMMIT;
SELECT * FROM REPLY_TAB;

BOARD_TAB과 REPLY_TAB을 JOIN해서 같이 출력하세요

SELECT B.NO, B.TITLE, B.USERID, B.WDATE, R.CONTENT, R.USERID
FROM BOARD_TAB B JOIN REPLY_TAB R
ON B.NO = R.NO_FK;

DELETE FROM BOARD_TAB WHERE NO=2;
-- ON DELETE CASCADE 옵션을 주었기 때문에 부모글을 삭제하면 자식글도 함께 삭제된다.

# UNIQUE KEY
컬럼수준 제약
CREATE TABLE UNI_TAB1(
    DEPTNO NUMBER(2) CONSTRAINT UNI_TAB1_DEPTNO_UK UNIQUE,
    DNAME CHAR(20),
    LOC CHAR(10)
);
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='UNI_TAB1';
INSERT INTO UNI_TAB1 VALUES(NULL,'영업부4','서울');
SELECT * FROM UNI_TAB1;
COMMIT;

테이블 수준 제약
UNI_TAB2
CREATE TABLE UNI_TAB2(
    DEPTNO NUMBER(2),
    DNAME CHAR(20),
    LOC CHAR(10),
    CONSTRAINT UNI_TAB2_DEPTNO_UK UNIQUE (DEPTNO)
);

# NOT NULL 제약조건 -체크제약조건의 일종
- NOT NULL 제약조건은 컬럼 수준에서만 제약할 수 있다.
CREATE TABLE NN_TAB(
    DEPTNO NUMBER(2) CONSTRAINT NN_TAB_DEPTNO_NN NOT NULL,
    DNAME CHAR(20) NOT NULL,
    LOC CHAR(10)
    -- CONSTRAINT LOC_NN NOT NULL (LOC) [X]
);

# CHECK 제약조건
- 행이 만족해야하는 조건을 정의한다

CREATE TABLE CK_TAB(
    DEPTNO NUMBER(2) CONSTRAINT CK_TAB_DEPTNO_CK CHECK ( DEPTNO IN (10,20,30,40)),
    DNAME CHAR(20)
);
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='CK_TAB';
INSERT INTO CK_TAB VALUES(50,'BAA'); --[X]

테이블 수준에서 CK_TAB2 LOC 는 '서울','수원' 값만 들어가도록 

CREATE TABLE CK_TAB2(
    DEPTNO NUMBER(2),
    DNAME CHAR(20),
    LOC CHAR(10),
    PRIMARY KEY (DEPTNO),
    CHECK (LOC IN ('서울','수원'))
);
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='CK_TAB2';

ZIPCODE 테이블 만들기
create table zipcode(
    post1 char(3),
    post2 char(3),
    addr varchar2(60) constraint zipcode_addr_nn not null,
    constraint zipcode_post_pk primary key(post1,post2)
);
desc zipcode;

MEMBER_TAB 테이블 만들기
create table member_tab(
    id number(4),
    name varchar2(10) constraint member_tab_name_nn not null,
    gender char(1),
    jumin1 char(6),
    jumin2 char(7),
    tel varchar2(15),
    post1 char(3),
    post2 char(3),
    addr  varchar2(60),
    constraint member_tab_id_pk primary key (id),
    constraint member_tab_gender_ck check ( gender in ('F','M')),
    constraint member_tab_jumin_uk unique (jumin1, jumin2),
    constraint member_tab_post_fk foreign key (post1, post2)
    references zipcode(post1, post2)
);
desc member_tab;

select * from user_constraints where table_name=upper('member_tab');

drop table member_tab5;

# subquery 를 이용한 테이블 생성

--사원 테이블에서 30번 부서에 근무하는 사원의 정보만 추출하여
--         EMP_30 테이블을 생성하여라. 단 열은 사번,이름,업무,입사일자,
--		  급여,보너스를 포함한다.

CREATE TABLE EMP_30(ENO, ENAME, JOB, HDATE, SAL,COMM)
AS
SELECT EMPNO, ENAME, JOB, HIREDATE, SAL, COMM 
FROM EMP WHERE DEPTNO=30;

SELECT * FROM EMP_30;
SELECT * FROM EMP WHERE DEPTNO=30;

-- [문제1]
--		EMP테이블에서 부서별로 인원수,평균 급여, 급여의 합, 최소 급여,
--		최대 급여를 포함하는 EMP_DEPTNO 테이블을 생성하라.
DROP TABLE EMP_DEPTNO;
CREATE TABLE EMP_DEPTNO
AS
SELECT  DEPTNO, COUNT(EMPNO) CNT, ROUND(AVG(SAL)) AVG_SAL, 
SUM(SAL) SUM_SAL, MIN(SAL) MIN_SAL, MAX(SAL) MAX_SAL
FROM EMP GROUP BY DEPTNO;

SELECT * FROM EMP_DEPTNO;
	
--	[문제2]	EMP테이블에서 사번,이름,업무,입사일자,부서번호만 포함하는
--		EMP_TEMP 테이블을 생성하는데 자료는 포함하지 않고 구조만
--		생성하여라
CREATE TABLE EMP_TEMP
AS
SELECT EMPNO, ENAME, JOB, HIREDATE, DEPTNO
FROM EMP WHERE 1=2;

SELECT * FROM EMP_TEMP;

--#DDL
--CREATE, DROP, ALTER, RENAME, TRUNCATE

--# 컬럼 추가 변경 삭제
ALTER TABLE 테이블명 ADD 추가할컬럼정보 [DEFAULT 값]
ALTER TABLE 테이블명 MODIFY 변경할컬럼정보
ALTER TABLE 테이블명 RENAME COLUMN OLD_NAME TO NEW_NAME;
ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명

CREATE TABLE TEMP(
NO NUMBER(4)
);
DESC TEMP;

TEMP테이블에 NAME컬럼을 추가하세요
TEMP 테이블에 INDATE추가하되 기본값은 SYSDATE

ALTER TABLE TEMP ADD NAME VARCHAR2(20) NOT NULL;
ALTER TABLE TEMP ADD INDATE DATE DEFAULT SYSDATE;

PRODUCTS 테이블에 PROD_DESC 컬럼을 추가하되 NOT NULL 제약조건을 주세요
ALTER TABLE PRODUCTS ADD PROD_DESC VARCHAR2(1000);
SELECT * FROM PRODUCTS;

TEMP테이블의 NO 컬럼의 자료형을 CHAR(4)로 수정하세요
ALTER TABLE TEMP MODIFY NO CHAR(4);
DESC TEMP;

TEMP 테이블의 NO 컬럼명을 NUM 으로 변경하세요
ALTER TABLE TEMP RENAME COLUMN NO TO NUM;

TEMP 테이블의 INDATE 컬럼을 삭제하세요
alter table temp DROP COLUMN INDATE;
DESC TEMP;

ALTER TABLE PRODUCTS DROP COLUMN PROD_DESC;
DESC PRODUCTS;

TEMP 테이블의 NUM 컬럼에 PRIMARY KEY 제약조건을 추가하세요
ALTER TABLE TEMP ADD CONSTRAINT TEMP_NUM_PK PRIMARY KEY (NUM);

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='TEMP';
INSERT INTO TEMP VALUES(1,'AAA');
SELECT * FROM TEMP;

제약조건 비활성화
ALTER TABLE 테이블명 DISABLE CONSTRAINT 제약조건명 [CASCADE];

TEMP의 PK제약조건을 비활성화 시키세요

ALTER TABLE TEMP DISABLE CONSTRAINT TEMP_NUM_PK;

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='TEMP';

DELETE FROM TEMP;
COMMIT;

제약조건 활성화
ALTER TABLE 테이블명 ENABLE CONSTRAINT 제약조건명 [CASCADE];

# 객체 이름 변경
RENAME OLD_NAME TO NEW_NAME;

TEMP 테이블명을 TEST테이블로 변경하세요

RENAME TEMP TO TEST_TEMP;

SELECT * FROM TAB;

# 테이블 삭제
DROP TABLE 테이블명 [CASCADE CONSTRAINT];

DROP TABLE TEST_TEMP CASCADE CONSTRAINT;

TEMP의 PK제약조건을 활성화 시키세요
ALTER TABLE TEMP ENABLE CONSTRAINT TEMP_NUM_PK;

DROP TABLE TEST PURGE;

테이블 모든 구조와 데이터가 삭제된다.
관련 인덱스도 모두 삭제된다.
VIEW, SYNONYM 정보는 데이터사전에는 남아있지만 사용하면 에러 발생한다
