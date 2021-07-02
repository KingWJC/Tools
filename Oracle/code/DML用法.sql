--�鿴���ݿ���־ģʽ
select log_mode from v$database
--�鿴���б�ռ�ͱ�ռ��С
select tablespace_name,sum(bytes)/1024/1024 as MB from dba_data_files group by tablespace_name;
--�鿴���б�ռ估���С��ʹ��ռ��
select a.tablespace_name,a.bytes/1024/1024/1024 "Sum GB",(a.bytes-b.bytes)/1024/1024/1024 "Used GB",b.bytes/1024/1024 "Free MB",round(((a.bytes-b.bytes)/a.bytes)*100,2) "Percent_Used" From 
(select tablespace_name,sum(bytes) bytes from dba_data_files group by tablespace_name) a,(select tablespace_name,sum(bytes) bytes,max(bytes) largest from dba_free_space group by tablespace_name) b 
where a.tablespace_name=b.tablespace_name order by ((a.bytes-b.bytes)/a.bytes) desc
--�鿴��ռ��Ӧ�������ļ�
select tablespace_name,file_name from dba_data_files
--�鿴���ݿ�s�����û��Ͷ�ӳ�ı�ռ�����
select UserName,account_status,Default_tablespace from dba_users;
--�鿴�û��µ����б���
select * from user_objects where lower(object_type)='table';

--ƴ���û������б���
--wm_concat �򵥣����г�������
select wm_concat(object_name) as tablename from user_objects where lower(object_type)='table'and object_name like '%TREND%';
--listagg �������ƣ�������4000
select listagg(object_name,',')within group(order by object_name) as tablename from user_objects where lower(object_type)='table'and object_name like '%TREND%';
--xmlagg ��rtrim����ʹ��
select rtrim(xmlagg(xmlparse(content object_name||',' wellformed) order by object_name).getclobval(),',') as tableName from user_objects where lower(object_type)='table'

--ÿ�ű�Ĵ�С ����������
select t.segment_name,t.segment_type,sum(t.bytes/1024/1024/1024) as "ռ�ÿռ䣨G��" from dba_segments t where  tablespace_name='JHICU_KM' group by OWNER,t.segment_name,t.segment_type

select * from user_extents

select a.segment_name,a.segment_type,a.bytes,a.bytes/1024/1024/1024 byte_g from dba_segments a inner join user_objects b on lower(b.object_type)='table' and  a.segment_name=b.object_name   order by a.bytes desc

--�����û���С��100M�ı���
select rtrim(xmlagg(xmlparse(content segment_name||',' wellformed) order by segment_name).getclobval(),',') as tableName  from (
select segment_name,sum(bytes)/1024/1024 as sizes from user_extents where segment_type='TABLE' group by segment_name) a where sizes<100  

--ʱ���������÷�
select * from MCS_ORDER_SCHEDULE where plan_time > to_date('2020-06-01','yyyy-MM-dd')


--��ѯ�������Ϣ
select * from dba_tab_partitions

--�����������Ұ����ı����ִ�Сд��
select * from user_tab_columns where column_name=upper('name')


--��ǰ������
select * from v$process
--���ݿ���������������
select value as '��������������' from v$parameter where name='processes'
--�޸����������:
alter system set processes = 300 scope = spfile;  
--ӵ��sysdba,sysoperȨ�޵��û�
select * from v$pwfile_users

--��ǰ��session������
select * from v$session where status='ACTIVE' --����������
--��ͬ�û���������
select username,count(username) from v$session where username is not null group by username


--���ݿ�·���ֵ�
select * from dba_directories


--ɾ��ͬһ��ռ��µ�һ���û�
--drop user JHICU cascade;


----��ѯoracle�������û���Ϣ
----1����ѯ���ݿ��еı�ռ�����

----1)��ѯ���б�ռ�

select tablespace_name from dba_tablespaces;
select tablespace_name from user_tablespaces;

----2)��ѯʹ�ù��ı�ռ�  

select distinct tablespace_name from dba_all_tables;

select distinct tablespace_name from user_all_tables;

----2����ѯ��ռ������б������

select *  from dba_all_tables where tablespace_name = 'SYNC_PLUS_1' and owner='GDSDCZJ'

----3����ѯϵͳ�û�

select * from all_users
select * from dba_users

----4���鿴��ǰ�����û�

select * from v$session

----5���鿴��ǰ�û�Ȩ��

select * from session_privs

----6���鿴���еĺ����ʹ洢����

select * from user_source

----����TYPE������PROCEDURE��FUNCTION

----7���鿴��ռ�ʹ�����
select  sum(Bytes_size) from (
select a.file_id "FileNo",
       a.tablespace_name "��ռ�",
       a.bytes/1024/1021/1024 Bytes_size,
       a.bytes - sum(nvl(b.bytes, 0)) "����",
       sum(nvl(b.bytes, 0)) "����",
       sum(nvl(b.bytes, 0)) / a.bytes * 100 "���аٷ���"
  from dba_data_files a, dba_free_space b
 where a.file_id = b.file_id(+)
 group by a.tablespace_name, a.file_id, a.bytes
 order by a.tablespace_name
 );




-----------------------------------------------------

----1.�鿴�����û���
select * from dba_users;
select * from all_users;
select * from user_users;

----2.�鿴�û����ɫϵͳȨ��(ֱ�Ӹ�ֵ���û����ɫ��ϵͳȨ��)��
select * from dba_sys_privs;
select * from user_sys_privs; (�鿴��ǰ�û���ӵ�е�Ȩ��)

----3.�鿴��ɫ(ֻ�ܲ鿴��½�û�ӵ�еĽ�ɫ)��������Ȩ��
sql>select * from role_sys_privs;

----4.�鿴�û�����Ȩ�ޣ�
select * from dba_tab_privs;
select * from all_tab_privs;
select * from user_tab_privs;

----5.�鿴���н�ɫ��
select * from dba_roles;

----6.�鿴�û����ɫ��ӵ�еĽ�ɫ��
select * from dba_role_privs;
select * from user_role_privs;

----7.�鿴��Щ�û���sysdba��sysoperϵͳȨ��(��ѯʱ��Ҫ��ӦȨ��)
select * from V$PWFILE_USERS

----8.SqlPlus�в鿴һ���û���ӵ��Ȩ��
SQL>select * from dba_sys_privs where grantee='username';
���е�username���û���Ҫ��д���С�
���磺
SQL>select * from dba_sys_privs where grantee='TOM';


----9��Oracleɾ��ָ���û����б�ķ���
select 'Drop table '||table_name||';' from all_tables
where owner='Ҫɾ�����û���(ע��Ҫ��д)';

----10��ɾ���û�
drop user user_name cascade;
�磺drop user SMCHANNEL CASCADE

----11����ȡ��ǰ�û������еı�
select table_name from user_tables;

----12��ɾ��ĳ�û������еı�����:
 select 'truncate table  ' || table_name from user_tables;

----13����ֹ���
----ORACLE���ݿ��е����Լ�������ڱ�user_constraints�п��Բ鵽������constraint_type='R'��ʾ�����Լ����
----�������Լ��������Ϊ��
alter table table_name enable constraint constraint_name
----�������Լ��������Ϊ��
alter table table_name disable constraint constraint_name
----Ȼ������SQL������ݿ������������Լ������
select 'alter table '||table_name||' enable constraint '||constraint_name||';' from user_constraints where constraint_type='R'
select 'alter table '||table_name||' disable constraint '||constraint_name||';' from user_constraints where constraint_type='R'

--14��ORACLE����/��������ʹ�����
--���ýű�
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

--���ýű�
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
