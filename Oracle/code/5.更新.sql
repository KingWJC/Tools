--DML ���ݿ��������

/*
���������
  Ԫ��ֵ�Ĳ���
  ��ѯ����Ĳ���

*/
--������Ĳ��뷽ʽ
--insert into tablename values(val1,val2,....) �������֮��û���У���ôֻ�ܽ����е��ж�����
--insert into tablename(col1,col2,...) values(val1,val2,...) ����ָ������Щ���в�������

insert into emp values(2222,'haha','clerk',7902,to_date('2019-11-2','YYYY-MM-dd'),1000,500,10);
select * from emp;
--�򲿷��в������ݵ�ʱ�򣬲��������ĸ��в���Ͳ���ģ�Ҫ��ѭ�������ʱ����Ĺ淶
insert into emp(empno,ename) values(3333,'wangwu')

--��ѯ����Ĳ���
Insert into tablename(column,..)
select * from tablename2

--1. ����һ����ʱ��
create table temp
as
select * from emp
where 1 = 2
--2. ִ�в���
insert into ss select * from emp;

/*
ɾ��������
 delete from tablename where condition

*/
--ɾ����������������
delete from emp2 where deptno = 10;
--�����ű������ȫ�����
delete from emp2;
--truncate ,��delete������ͬ��delete�ڽ���ɾ����ʱ�򾭹����񣬶�truncate����������һ��ɾ����������ɾ�������߱��ع��Ĳ���
--Ч�ʱȽϸߣ��������׷�������������Բ�����ʹ��
truncate table emp2


/*
�޸Ĳ�����
   update tablename set col = val1,col2 = val2 where condition;
   ���Ը��»����޸�����������һ���л��߶����
*/
--���µ���
update emp set ename = 'heihei' where ename = 'hehe';
--���¶���е�ֵ
update emp set job='teacher',mgr=7902 where empno = 15;




--���񣺱�ʾ�������ϣ����ɷָҪôȫ���ɹ���Ҫôȫ��ʧ��
insert into emp(empno,ename) values(2222,'zhangsan');
--commit;
--rollback;
select * from emp;

--DDL���ִ���Զ��ύ����
insert into test02  select * from emp where emp.deptno=10;
create table test04 as select * from emp where 1=2��

--savepoint  �����
--��һ�����������а�������SQL��䣬����ֻ��������ĳ���ֳɹ���ĳ����ʧ�ܣ���ʱ����ʹ�ñ����
--��ʱ�����Ҫ�ع���ĳһ��״̬�Ļ�ʹ�� rollback to sp1;
delete from emp where empno = 1111;
delete from emp where empno = 2222;
savepoint sp1;
delete from emp where empno = 1234;
rollback to sp1;
commit;
