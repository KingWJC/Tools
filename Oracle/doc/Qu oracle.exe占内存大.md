问题：资源管理器中，oracle.exe一直占很大内存，为6个多G。

解决方案：

> Oracle内存组件中，有一个叫做SGA的部分，这个部分如果设置了7G，启动之后，立马从内存中分割出7G，哪怕当前Oracle只用了100M。这7G也是不可以被其他任何机制回收和利用的。而且Oracle是典型的耗内存应用，SGA组件里的BufferCache放的是真实的用户数据。可以避免分散的磁盘操作，而直接在SGA中完成对数据库的修改加工。SGA是主要占内存的组件。其他PGA等等为用多少分配多少的基本原则。会发生回收机制的。除此之外，你可以通过show parameter sga查看SGA的具体设置。

> oracle占用内存不会无限向上，而是预先划一片SGA和PGA，是固定的。如果是win系统默认安装，这个参数会是整机内存的40%。

- 查设置参数
- sqlplus/ as sysdba
- Show parameter sga
- Show parameter pga
- 设置 Alter system set sga_target=2000M SCOPE=spfile;
- 同理修改 sga_max_size=2000m,pga_aggregate_target=300m
- 重启数据库实例

参考资料：Oracle内存结构：SGA PGA UGA

https://www.cnblogs.com/caodneg7/p/11411728.html

如果内存一直增大，导致服务器崩溃。可能是一个oracle 的会话占用了大量的内存：

```sql
SELECT server "连接类型",  s.username,  oSUSEr, NAME,  VALUE/1024/1024 "占用内存MB",  
s.SID "会话ID", s.serial#,  spid "操作系统进程ID", p.PGA_USED_MEM,  p.PGA_ALLOC_MEM, 
 p.PGA_FREEABLE_MEM, p.PGA_MAX_MEM 
FROM v$session s, v$sesstat st, v$statname sn, v$process p 
WHERE st.SID = s.SID AND st.statistic# = sn.statistic# AND 
sn.NAME LIKE 'session pga memory' AND p.addr = s.paddr ORDER BY VALUE DESC
```

此会话的PGA_USED_MEM, PGA_ALLOC_MEM, PGA_FREEABLE_MEM, PGA_MAX_MEM 等值可以达到4G左右，可以断定是会话的问题。 经查虽然我们在oracle中限定了PGA的大小也就是配置了PGA_AGGREGATE_TARGET ，但是PGA_AGGREGATE_TARGET作为一个Target Oracle只会做的尽量不超过此值，并不保证一定不超过。 情况很明显某个会话大量执行没有结束占用了内存。 下面可以通过各种方法查明回来的来源。