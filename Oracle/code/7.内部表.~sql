
--dual是oracle中提供的一张虚拟表，不表示任何意义，在测试的时候可以随意使用

/* 建库
   1.表空间
   2.用户
   3.权限
   4.数据
   5.分区
   6.路径
   7.连接
*/

--1、查询数据库中的表空间名称
----1)查询所有表空间
select tablespace_name from dba_tablespaces;
select tablespace_name from user_tablespaces;
----2)查询使用过的表空间  
select distinct tablespace_name from dba_all_tables;
select distinct tablespace_name from user_all_tables;
----3)查询表空间中所有表的名称
select *  from dba_all_tables where tablespace_name = 'SYNC_PLUS_1' and owner='GDSDCZJ'
--2、查询系统用户，角色和权限
----1)查询系统用户
select * from dba_users;
select * from all_users;
select * from user_users;
----2)查看当前连接用户
select * from v$session
----3)查看用户或角色系统权限
select * from dba_sys_privs where grantee=upper('username');
select * from user_sys_privs; --(查看当前用户所拥有的权限)
select * from session_privs
----4)查看用户对象权限：
select * from dba_tab_privs;
select * from all_tab_privs;
select * from user_tab_privs;
----5)查看所有角色：
select * from dba_roles;
----6)查看角色的权限(只能查看登陆用户拥有的角色)所包含的权限
select * from role_sys_privs;
----7)查看用户或角色所拥有的角色：
select * from dba_role_privs;
select * from user_role_privs;
----8)查看哪些用户有sysdba或sysoper系统权限(查询时需要相应权限)
select * from V$PWFILE_USERS
--3、获取当前用户下所有的表：
select table_name from user_tables;
----1)当前用户下的所有表和视图
SELECT * FROM TAB; 
----2)查询当前用户下所有表的表名和表说明：
select t.table_name,f.comments from user_tables t  inner join user_tab_comments f on t.table_name = f.table_name; 
----3)查询当前用户下所有表的字段名
select * from user_col_comments t; 
----4)查看表结构
DESC TABLENAME; 
--4、查看所有的函数和存储过程
select * from user_source  ----其中TYPE包括：PROCEDURE、FUNCTION
--5、删除当前用户下所有的表数据:
 select 'truncate table  ' || table_name from user_tables;
--6、查看/删除指定用户的所有表的方法
select * from all_tables a where a.OWNER = upper('数据库用户名');   --选择用户下都有哪些表
select 'Drop table '||table_name||';' from all_tables where owner=upper('username');



--查看表空间（对应的数据文件）
select tablespace_name,file_name,bytes from dba_data_files
--查看用户（对映的表空间名称）
select UserName,account_status,Default_tablespace from dba_users;
--查看用户下对象（所有表）
select * from user_objects where lower(object_type)='table';
--查看数据库日志模式
select log_mode from v$database
--查询表分区信息
select * from dba_tab_partitions
--数据库路径字典
select * from dba_directories


/* 应用
   1.数据库连接数。
*/

--拼接用户下所有表名
--wm_concat 简单，但有长度限制
select wm_concat(object_name) as tablename from user_objects where lower(object_type)='table'and object_name like '%TREND%';
--listagg 长度限制，不超过4000
select listagg(object_name,',')within group(order by object_name) as tablename from user_objects where lower(object_type)='table'and object_name like '%TREND%';
--xmlagg 与rtrim搭配使用
select rtrim(xmlagg(xmlparse(content object_name||',' wellformed) order by object_name).getclobval(),',') as tableName from user_objects where lower(object_type)='table'

--当前连接数
select * from v$process
--数据库允许的最大连接数
select value as '允许的最大连接数' from v$parameter where name='processes'
--修改最大连接数:
alter system set processes = 300 scope = spfile;  
--拥有sysdba,sysoper权限的用户
select * from v$pwfile_users

--当前的session连接数
select * from v$session where status='ACTIVE' --并发连接数
--不同用户的连接数
select username,count(username) from v$session where username is not null group by username


--每张表的大小 表数量不足
select t.segment_name,t.segment_type,sum(t.bytes/1024/1024/1024) as "占用空间（G）" from dba_segments t where  tablespace_name='JHICU_KM' group by OWNER,t.segment_name,t.segment_type

select * from user_extents

select a.segment_name,a.segment_type,a.bytes,a.bytes/1024/1024/1024 byte_g from dba_segments a inner join user_objects b on lower(b.object_type)='table' and  a.segment_name=b.object_name   order by a.bytes desc

--查找用户下小于100M的表名
select rtrim(xmlagg(xmlparse(content segment_name||',' wellformed) order by segment_name).getclobval(),',') as tableName  from (
select segment_name,sum(bytes)/1024/1024 as sizes from user_extents where segment_type='TABLE' group by segment_name) a where sizes<100  

--时间条件的用法
select * from MCS_ORDER_SCHEDULE where plan_time > to_date('2020-06-01','yyyy-MM-dd')





----13、禁止外键
----ORACLE数据库中的外键约束名都在表user_constraints中可以查到。其中constraint_type='R'表示是外键约束。
----启用外键约束的命令为：
alter table table_name enable constraint constraint_name
----禁用外键约束的命令为：
alter table table_name disable constraint constraint_name
----然后再用SQL查出数据库中所以外键的约束名：
select 'alter table '||table_name||' enable constraint '||constraint_name||';' from user_constraints where constraint_type='R'
select 'alter table '||table_name||' disable constraint '||constraint_name||';' from user_constraints where constraint_type='R'

--14、ORACLE禁用/启用外键和触发器
--启用脚本
SET SERVEROUTPUT ON SIZE 1000000
BEGIN
for c in (select 'ALTER TABLE '||TABLE_NAME||' ENABLE CONSTRAINT '||constraint_name||' ' as v_sql from user_constraints where CONSTRAINT_TYPE='R') loop
DBMS_OUTPUT.PUT_LINE(C.V_SQL);
begin
 EXECUTE IMMEDIATE c.v_sql;
 exception when others then
 dbms_output.put_line(sqlerrm);
 end;
end loop;
for c in (select 'ALTER TABLE '||TNAME||' ENABLE ALL TRIGGERS ' AS v_sql from tab where tabtype='TABLE') loop
 dbms_output.put_line(c.v_sql);
 begin
 execute immediate c.v_sql;
exception when others then
 dbms_output.put_line(sqlerrm);
 end;
end loop;
end;
/
commit;

--禁用脚本
SET SERVEROUTPUT ON SIZE 1000000
BEGIN
for c in (select 'ALTER TABLE '||TABLE_NAME||' DISABLE CONSTRAINT '||constraint_name||' ' as v_sql from user_constraints where CONSTRAINT_TYPE='R') loop
DBMS_OUTPUT.PUT_LINE(C.V_SQL);
begin
 EXECUTE IMMEDIATE c.v_sql;
 exception when others then
 dbms_output.put_line(sqlerrm);
 end;
end loop;
for c in (select 'ALTER TABLE '||TNAME||' DISABLE ALL TRIGGERS ' AS v_sql from tab where tabtype='TABLE') loop
 dbms_output.put_line(c.v_sql);
 begin
 execute immediate c.v_sql;
exception when others then
 dbms_output.put_line(sqlerrm);
 end;
end loop;
end;
/
commit;
