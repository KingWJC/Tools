 --创建表的时候需要给表中的数据添加数据校验规则，这些规则称之为约束
 /*
 约束分为五大类
 not null: 非空约束，插入数据的时候某些列不允许为空
 unique key:唯一键约束，可以限定某一个列的值是唯一的，唯一键的列一般被用作索引列。
 primary key:主键：非空且唯一，任何一张表一般情况下最好有主键，用来唯一的标识一行记录，
 foreign key:外键，当多个表之间有关联关系（一个表的某个列的值依赖与另一张表的某个值）的时候，需要使用外键
 check约束:可以根据用户自己的需求去限定某些列的值
 */


--建表,注释，默认值
CREATE TABLE TEST_DEPT
(
  ID NUMBER(10) PRIMARY KEY,
  NAME VARCHAR2(20) NOT NULL
);
COMMENT ON TABLE TEST_DEPT IS '部门信息';
COMMENT ON COLUMN TEST_DEPT.NAME IS '部门名称';

CREATE TABLE TEST_USER
(
  ID NUMBER(10) PRIMARY KEY,
  NAME VARCHAR2(20) NOT NULL,
  AGE NUMBER(3) CHECK(AGE>0 AND AGE<200),
  STATE NUMBER(1) DEFAULT 0,
  EMAIL VARCHAR2(50) UNIQUE NOT NULL,
  CREATE_DATE DATE,
  DEPT_NO NUMBER(10)
);
COMMENT ON TABLE TEST_USER IS '用户信息';
COMMENT ON COLUMN TEST_USER.NAME IS '用户名';

--修改表结构
--添加新列，都为可为空，不能设置成not null
ALTER TABLE TEST_USER ADD ADDRESS VARCHAR2(100);
ALTER TABLE TEST_USER MODIFY(ADDRESS VARCHAR2(200));
ALTER TABLE TEST_USER DROP COLUMN ADDRESS;

--表的重命名
RENAME TEST_USER TO USER;
--删除表
/*
在删除表的时候，经常会遇到多个表关联的情况，多个表关联的时候不能随意删除，需要使用级联删除
cascade: 如果A,B,A中的某一个字段跟B表中的某一个字段做关联，那么再删除表A的时候，需要先将表B删除
set null: 再删除的时候，把表的关联字段设置成空
*/
DROP TABLE TEST_USER;
DROP TABLE TEST_DEPT;

 --添加外键约束,最好先把外键关联表的数据优先插入
ALTER TABLE TEST_USER ADD CONSTRAINT FK_0001 FOREIGN KEY(DEPT_NO) REFERENCES TEST_DEPT(ID);
