### Oracle数据类型

[Oracle---number数据类型](https://www.cnblogs.com/jiangfeilong/p/10923899.html)

## [Oracle的Number对应C#数据类型](https://www.cnblogs.com/seasblog/p/11393566.html)

Number(9,0)及以下使用intNumber(10,0)到Number(19,0)使用longNumber(20,0)及以上使用decimal

EntityFramework使用Number(20,0)及以上Number时需要手动配置精度：Property(x => x.Code).HasPrecision(20,0)

对于有小数位的：EntityFramework使用decimal然后手动配置精度Dapper直接使用decimal接收返回值

https://www.cnblogs.com/jiangfeilong/p/10923899.ht

## 未解决问题：

OCI_ERROR 1036，Oracle数据插入错误，参数类型问题。

获取类型的属性，t.GetAttribute<>().Name

DataTable中byte[]类型的数据如何存储。String

类型转换Convert的用法，byte[]无法转换。

```
string s = (string)ds.Tables[0].Rows[0]["ProjectIcons"];
byte[] data = System.Text.Encoding.ASCII.GetBytes(s);
```

byte [] stringArray = Encoding.UTF8.GetBytes("aaa");

CMMI5 工作产出和模型对比。 PI工作内容: 集成化策略，集成环境，jekens工作。 就绪检查，组件，集成后检查， swiki，swege接口管理，覆盖范围，完整性和一致性，持续性的更新和评价。（版本记录） 接口的兼容性。支持多种格式的输出。swinbook。 产品组件化。 产品集成计划。 集成策略的选择，测试工具，集成环境

后台：

1. Oracle数据插入错误：OCI_ERROR 1036 原因：执行SQL语句时的参数前缀的设置错误。每个数据库的格式不一样。
2. Oracle和SQL生成插入或更新语句时，列名使用双引号包含，中括号只适用于SQL Server.。通用的为双引号。
3. IDispose接口，实现。
4. ADO.NET内部类的关系和特性。
5. 实现过程： 1.定义枚举类 DataBaseType 用于参数选择操作的数据库类型，实例化工厂。 5.在执行Sql查询的时候，使用工厂生成实例，和参数来进行操作。

本类分为 ExecuteNonQuery、ExecuteScalar、ExecuteScalar、ExecuteDataTable、ExecuteDataSet、ExecuteList Entity、ExecuteEntity七大部分，每一部分分为 无条件参数执行Sql语句或存储过程、SqlParameter[]参数执行Sql语句，Object[]参数执行存储过程三个重载方法

[一个通用数据库操作组件DBUtil(c#)、支持SqlServer、Oracle、Mysql、postgres、Access、SQLITE_火焰-CSDN博客](https://blog.csdn.net/u010476739/article/details/54882950)

[未在本地计算机上注册"OraOLEDB.Oracle"提供程序](https://www.cnblogs.com/polk6/archive/2013/03/22/2976028.htm)

https://blog.csdn.net/agura/article/details/87113137

OraOLEDB需要安装客户端。

[循序渐进VUE+Element 前端应用开发(25）--- 各种界面组件的使用（1） - 伍华聪 - 博客园](https://www.cnblogs.com/wuhuacong/p/13917742.html)



[如何将备份的oracle数据库还原到指定用户下。](https://www.cnblogs.com/grisa/p/10063170.html)

Oracle 索引创建：

[oracle 常用索引分析，使用原则和注意事项](https://www.cnblogs.com/xjx199403/p/10675854.html)

[Oracle创建索引的基本规则_ITPUB博客](http://blog.itpub.net/22609129/viewspace-1116143/)

索引查询

SELECT INDEX_NAME,INDEX_TYPE,TABLESPACE_NAME,UNIQUENESS FROM ALL_INDEXES WHERE TABLE_NAME='TABLE_NAME'

- -根据索引名，查询表索引字段

select * from user_ind_columns where index_name='索引名';

- -根据表名，查询一张表的索引

select * from user_indexes where table_name='表名';

索引创建

CREATE INDEX INDEX_NAME ON TABLE_NAME(COLUMN_NAME)   —创建Normal类型的索引

CREATE INDEX INDEX_NAME ON TABLE_NAME(‘COLUMN_NAME’)  —字段名加引号，则创建基于函数的索引

删除索引

DROP INDEX INDEX_NAME

metalink文章：

[My Oracle Support](https://support.oracle.com/)

Metalink是Oracle的官方技术支持站点　Oracle公司通过该网站来支持全球的客户，据Oracle公司的统计资料，据说80%的技术问题都是通过Metalink网上解决的。　Metalink的注册并非免费。当你购买了Oracle公司的软件以后，可以根据License向Oracle请求CSI(Customer Support Identifier)号,通过CSI号你就可以登录Metalink站点注册。

Oracle用户被锁原因及解决办法 1、遇到登录报用户被锁时，先不要着急解锁，先使用dba角色的用户登录，设置具体时间格式，以便我们查询具体的被锁时间： SQL> alter session set nls_date_format=’yyyy-mm-dd hh24:mi:ss’;

2、查看具体被锁时间： SQL> select username,lock_date from dba_users where username=’USERNAME’;

3、解锁被锁用户： SQL> alter user USERNAME account unlock;

4、查看是那个ip造成的USERNAME 用户被锁 主要监听日志，一般路径为：$ORACLE_HOME/network/admin/log/listener.log日志 win系统下：d:\app\orcl\product\12.1.0\dbhome_1\log\diag\tnslsnr\02843ZYT\listener\alert\log.xml 如果实在找不到，可以在终端或cmd窗口输入lsnrctl status 输出的信息中会有监听的日志文件路径

5、根据监听日志中的信息，可以看出在这个时间段IP为10.69.1.11在尝试多次失败登陆造成的被锁 10-MAR-2009 08:51:03 * (CONNECT_DATA=(SID=lhoms)(SERVER=DEDICATED)(CID=(PROGRAM=oracle)(HOST=omstestdb)(USER=oraoms))) * (ADDRESS=(PROTOCOL=tcp)(HOST=10.69.1.11)(PORT=49434)) * establish * lhoms * 0

注： 一般数据库默认是10次尝试失败后锁住用户 1、查看FAILED_LOGIN_ATTEMPTS的值 select * from dba_profiles 2、修改为30次 alter profile default limit FAILED_LOGIN_ATTEMPTS 30; 3、修改为无限次(为安全起见，不建议使用) alter profile default limit FAILED_LOGIN_ATTEMPTS unlimited;

Oracle增加删除列 ALTER TABLE table_name ADD column_3 number(28,10); ALTER TABLE table_name DROP COLUMN column_name;

Oracle获取字符集： SELECT value$ FROM sys.props$ WHERE name = 'NLS_CHARACTERSET' ; SELECT * FROM NLS_DATABASE_PARAMETERS

Oracle建库脚本： 1.创建表空间 sql命令： create tablespace jeefh2_gblz17 logging datafile ‘/u02/oradata/orcl/jeefh2_gblz17.dbf’ --表空间文件存储位置 size 1024m --表空间文件初始大小 autoextend on --表空间自动增长 next 100m maxsize unlimited --自动增长文件大小及最大空间 extent management local; 2.创建用户 sql命令： create user jeefh2_gblz17 identified by jeefh2_gblz17 default tablespace jeefh2_gblz17 temporary tablespace temp; 3.给用户授予权限 sql命令： grant connect,resource,dba to jeefh2_gblz17; 4.导出/导入表结构 5.导出/导入表数据  (在cmd命令窗口执行，而不是sqlplus.exe) 导出（exdmp 用户名/密码 dumpfile=文件名称.dmp） expdp jhicuv3_1/jhicu@10.1.1.144/JHICU_BYSY dumpfile=database.dmp (inctype=complete/incremental/cumulative累积增量) 导入(impdp 用户名/密码 dumpfile=要导入的文件名.dmp REMAP_SCHEMA=导出的用户名:导入的用户名 EXCLUDE=USER) impdp jhicuv3_1/jhicu@10.2.98.213/MyOrcl dumpfile=database.dmp REMAP_SCHEMA=jhicuv3_1:jhicuv3_1 EXCLUDE=USER table_exists_action=replace

table_exists_action参数说明

1. skip：跳过，默认操作
2. replace：先drop表，然后创建表，最后插入数据
3. append：在原来数据的基础上增加数据
4. truncate：先truncate，然后再插入数据 当表结构变化时， table_exists_action参数使用Replace，相同时，可以使用Trancate。

directory参数： 指定转储文件和日志文件所在的目录。Directory=directory_object(用于指定目录对象名称，可查询dba_directories） --新建或修改路径 PATH （如何执行) CREATE or REPLACE directory PATH as 'e:\' --授权 grant read,write on directory PATH to jhicuv3_1 --查询路径字典 select * from dba_directories --查询目录和权限

dumpfile参数： 指定转储文件的名称，dumpfile=[directory_object:]file_name，若不指定directory参数，则使用默认路径。

将数据库中的表table1 、table2导出 exp jhicuv3_1/jhicu@10.1.1.144/JHICU_BYSY  file=e:\test.dmp tables=(PAT_VIDIT,BED_REC) expdp jhicuv3_1/jhicu@10.1.1.144/JHICU_BYSY directory=PATH dumpfile=Test.dmp Tables=(PAT_VIDIT,BED_REC)  (query="where rownum<11")  (full=y)  (tablespaces=表空间名称）

将E:\Test.dmp中的表table1 导入 imp jhicuv3_1/jhicu@10.2.98.213/MyOrcl file=e:\Test.dmp  tables=(PAT_VIDIT,BED_REC) ignore=y （inctype=RESTORE） impdp jhicuv3_1/jhicu@10.2.98.213/MyOrcl directory=PATH dumpfile=Test.dmp Tables=(PAT_VIDIT,BED_REC) table_exists_action=replace

exp中 file为绝对路径， 不指定tables时，导出用户下所有表。 expdp中 dumpfile为相对路径，需指定directory。 imp 无法覆盖。如果已存在表，会报错IMP-00015，需要加ignore=y。 如果主键无冲突，则追加，否则报错。 full=y 不指定tables表示全部导入。

逻辑备份表，附带筛选条件，条件中有字符串：需要转义双引号。 expdp jhicuv3_1/jhicu@10.1.1.144/JHICU_BYSY directory=PATH dumpfile=bysy.dmp Tables=(MCS_ORDER_SCHEDULE) query=MCS_ORDER_SCHEDULE:\"where plan_time > to_date('2020/06/01','yyyy-MM-dd')\",table2:\"where rownum<5\"

命令窗体cmd中导出过程中，终止导出，导出的文件无法删除，已在OracleServiceBYSY中打开 解决方案：关闭导出的进程exp.exe.

Oracle的备份和还原。 Rman物理备份-热备份：针对数据库，表空间，数据文件，数据块，速度慢。 SQL> archive log list           --SQLPlus下执行，数据建议运行在归档模式下 设定数据库运行于归档模式下： SQL>shutdown immediate SQL>startup mount SQL> alter database archivelog; SQL> alter database open; C:/administrator rman target /     --CMD用户目录下，以rman模式登录数据库。 backup database  全库备份 backup tablespace 表空间名称。select name from v$tablespace; recover tablespace 表空间名称

拷贝数据库文件-物理备份-冷备份：非归档模式。数据库必须关闭。 su – oracle <      sqlplus /nolog connect / as sysdba shutdown immediate;  首先关闭数据库 !cp 文件   备份位置（所有的日志、数据、控制及参数文件）;   拷贝相关文件到安全区域（利用操作系统命令拷贝数据库的所有的数据文件、日志文件、控制文件、参数文件、口令文件等（包括路径）） startup;    重新启动数据库 exit;

exp,expdbp逻辑备份：针对用户，数据库对象（表，分区...）,数据完整性不是很好。 问题：逻辑还原必须使用相同的用户。

Oracle中Top的用法： Oracle不支持select top 语句，所以在Oracle中经常是用order by 跟rownum 的组合来实现select top n的查询。 如：select id,name from (select id,name from student order by name) where rownum<=10 order by rownum asc 或者使用分析函数：row_number() over ( partition by col1 order by col2 )。先生成序列号，再取数据。

PLSQL使用工具中的，导出用户对象。来导出表结构，存储过程

imp/exp可导出表结构和数据。

导入：

imp jhicu/jhicu@10.1.1.14/jhicu fromuser=JHICU_AH touser=jhicu file=d:\abcd.dmp tables=（JHICU_SYSTEM_CONFIG，tableB）

imp错误；

遇到Oracle错误959

表空间“JHICU_DATA"不存在。

使用imp，必须保证表空间一致。

https://www.cnblogs.com/whatlonelytear/p/8021781.html

存储过程执行：无法找到正在调用的程序单元oracle

重新编译。Package和PackageBody。





[sql查询两条记录的时间差 - 博客王大锤 - 博客园](https://www.cnblogs.com/wangxinblog/p/7835010.html)

[Oracle11g如何清理数据库的历史日志详解-编程脚本学习网](https://www.ddpool.cn/article/30791.html)

[ORA-00060: 等待资源时检测到死锁_haojiubujian920416的博客-CSDN博客](https://blog.csdn.net/haojiubujian920416/article/details/81876647)

[关于"ORA-00060:等待资源时检测到死锁"问题的分析_fupei的专栏-CSDN博客_等待资源时检测到死锁](https://blog.csdn.net/fupei/article/details/7168880?utm_medium=distribute.pc_relevant_t0.none-task-blog-searchFromBaidu-1.not_use_machine_learn_pai&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-searchFromBaidu-1.not_use_machine_learn_pai)

触发器，

https://blog.csdn.net/qq_38819293/article/details/86526696

关于文件保存到Oracle中BLOB字段的方法。

[Oracle架构、原理、进程](https://cloud.tencent.com/developer/article/1531025?from=information.detail.oracle服务器 内存释放)
