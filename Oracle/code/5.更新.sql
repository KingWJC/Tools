--DML 数据库操作语言

/*
插入操作：
  元组值的插入
  查询结果的插入

*/
--最基本的插入方式
--insert into tablename values(val1,val2,....) 如果表名之后没有列，那么只能将所有的列都插入
--insert into tablename(col1,col2,...) values(val1,val2,...) 可以指定向哪些列中插入数据

insert into emp values(2222,'haha','clerk',7902,to_date('2019-11-2','YYYY-MM-dd'),1000,500,10);
select * from emp;
--向部分列插入数据的时候，不是想向哪个列插入就插入的，要遵循创建表的时候定义的规范
insert into emp(empno,ename) values(3333,'wangwu')

--查询结果的插入
Insert into tablename(column,..)
select * from tablename2

--1. 创建一个临时表
create table temp
as
select * from emp
where 1 = 2
--2. 执行插入
insert into ss select * from emp;

/*
删除操作：
 delete from tablename where condition

*/
--删除满足条件的数据
delete from emp2 where deptno = 10;
--把整张表的数据全部清空
delete from emp2;
--truncate ,跟delete有所不同，delete在进行删除的时候经过事务，而truncate不经过事务，一旦删除就是永久删除，不具备回滚的操作
--效率比较高，但是容易发生误操作，所以不建议使用
truncate table emp2


/*
修改操作：
   update tablename set col = val1,col2 = val2 where condition;
   可以更新或者修改满足条件的一个列或者多个列
*/
--更新单列
update emp set ename = 'heihei' where ename = 'hehe';
--更新多个列的值
update emp set job='teacher',mgr=7902 where empno = 15;




--事务：表示操作集合，不可分割，要么全部成功，要么全部失败
insert into emp(empno,ename) values(2222,'zhangsan');
--commit;
--rollback;
select * from emp;

--DDL语句执行自动提交事物
insert into test02  select * from emp where emp.deptno=10;
create table test04 as select * from emp where 1=2；

--savepoint  保存点
--当一个操作集合中包含多条SQL语句，但是只想让其中某部分成功，某部分失败，此时可以使用保存点
--此时如果需要回滚到某一个状态的话使用 rollback to sp1;
delete from emp where empno = 1111;
delete from emp where empno = 2222;
savepoint sp1;
delete from emp where empno = 1234;
rollback to sp1;
commit;
