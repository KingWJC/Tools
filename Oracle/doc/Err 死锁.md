### 死锁原因

1. 删除和更新之间引起的死锁
   1. 多个线程或进程对同一个资源的争抢或相互依赖.
   2. 在sql 窗口 执行：SELECT * FROM testLock FOR UPDATE; -- 加行级锁 并对内容进行修改，不要提交
   3. 另开一个command窗口，执行：delete from testLock WHERE ID=1;
2. 子表外键上没有建立索引所致
   1. 会话1中删除子表数据，在会话2中删除主表数据，会话被锁。
   2. 删除主表的时候会去寻找所有以主表的主键作为外键的数据表，然后看去看从表是否有该外键的索引，如果没有则会对整个从表施加表级锁，然后对从表进行全表扫描。当然如果从表存在外键的索引，会去访问对应的索引，而不会对从表本身进行加锁
3. 并发批量update同一张表引起的死锁
4. 表空间使用率超过99%，批处理插入命令死锁。

### 解决方案

表的死锁查找：

```sql
SELECT SESS.SID,  SESS.SERIAL#,  LO.ORACLE_USERNAME,  LO.OS_USER_NAME,  SESS.
AO.OBJECT_NAME 被锁对象名, LO.LOCKED_MODE 锁模式, sess.LOGON_TIME 登录数据库时间,
'ALTER SYSTEM KILL SESSION ''' || SESS.SID || ','||SESS.SERIAL#||'''' FREESQL,SA.SQL_TEXT,SA.ACTION
FROM V$LOCKED_OBJECT LO,  DBA_OBJECTS AO,  V$SESSION SESS ，V$SQLAREA SA
WHERE AO.OBJECT_ID = LO.OBJECT_ID AND LO.SESSION_ID = SESS.SID AND SA.ADDRESS = SESS.PREV_SQL_ADDR
ORDER BY sid, sess.serial#;
```

执行FREESQL列，杀掉对应进程。

Status：用来判断session状态。Active：正执行SQL语句。Inactive：等待操作。Killed：被标注为删除。

Machine： 死锁语句所在的机器。

Program： 产生死锁的语句主要来自哪个应用程序

- 锁模式 locked_mode

  0：none

  1：null 空

  2：Row-S 行共享(RS)：共享表锁，sub share

  3：Row-X 行独占(RX)：用于行的修改，sub exclusive

  4：Share 共享锁(S)：阻止其他DML操作，share

  5：S/Row-X 共享行独占(SRX)：阻止其他事务操作，share/sub exclusive

  6：exclusive 独占(X)：独立访问使用，exclusive

### 减少死锁的方法

1.按同一顺序访问对象。

2.避免事务中的用户交互。

3.保持事务简短并处于一个批处理中。

4.使用较低的隔离级别，如：使用nolock参数，让SELECT语句不要申请S锁。

5.调整索引，以调整执行计划，减少锁的申请数目，从而消除死锁。

\6. 升级锁的粒度，将死锁转化成一个阻塞问题。

### 1.表空间数据文件和容量指标查询：

```sql
select tablespace_name,file_id,file_name,round(bytes / (1024 * 1024), 0) total_space
from sys.dba_data_files order by tablespace_name;

SELECT TABLESPACE_NAME "表空间",
       To_char(Round(BYTES / 1024, 2), '99990.00')
       || ''           "实有",
       To_char(Round(FREE / 1024, 2), '99990.00')
       || 'G'          "剩余",
       To_char(Round(( BYTES - FREE ) / 1024, 2), '99990.00')
       || 'G'          "使用",
       To_char(Round(10000 * USED / BYTES) / 100, '99990.00')
       || '%'          "比例"
FROM   (SELECT A.TABLESPACE_NAME                             TABLESPACE_NAME,
               Floor(A.BYTES / ( 1024 * 1024 ))              BYTES,
               Floor(B.FREE / ( 1024 * 1024 ))               FREE,
               Floor(( A.BYTES - B.FREE ) / ( 1024 * 1024 )) USED
        FROM   (SELECT TABLESPACE_NAME TABLESPACE_NAME,
                       Sum(BYTES)      BYTES
                FROM   DBA_DATA_FILES
                GROUP  BY TABLESPACE_NAME) A,
               (SELECT TABLESPACE_NAME TABLESPACE_NAME,
                       Sum(BYTES)      FREE
                FROM   DBA_FREE_SPACE
                GROUP  BY TABLESPACE_NAME) B
        WHERE  A.TABLESPACE_NAME = B.TABLESPACE_NAME)
--WHERE TABLESPACE_NAME LIKE 'CDR%' --这一句用于指定表空间名称
ORDER  BY Floor(10000 * USED / BYTES) DESC;
```

### 2.表空间扩容

```sql
--1：手工改变已存在数据文件的大小
ALTER DATABASE DATAFILE 
'E:\\APP\\ADMINISTRATOR\\ORADATA\\JHICU_BYSY\\JHICU_KM10.DBF' RESIZE 4096M;
--2：允许已存在的数据文件自动增长
ALTER DATABASE DATAFILE 'E:\\APP\\ADMINISTRATOR\\ORADATA\\JHICU_BYSY\\JHICU_KM10.DBF'
AUTOEXTEND ON NEXT 100M MAXSIZE 20480M;
--3：增加数据文件，一个数据文件最大不超过32Gb
ALTER TABLESPACE JHICU_KM ADD DATAFILE
'E:\\APP\\ADMINISTRATOR\\ORADATA\\JHICU_BYSY\\JHICU_KM10.DBF' 
size 4167M autoextend on ;
```

ORACLE的表空间使用率达到99%时，批量数据无法插入。