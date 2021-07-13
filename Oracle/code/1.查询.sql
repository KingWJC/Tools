/*sql���ѧϰ

SELECT [DISTINCT] {*,column alias,..}
FROM table alias
Where �������ʽ
GROUP BY group_by_expression
ORDER BY column 
HAVING condition

*/

--��ѯ��Ա���в��ű����10��Ա��
select empno,ename,job from emp where deptno = 10;
--dinstinct ȥ���ظ�����
select distinct deptno from emp;
--ȥ��Ҳ������Զ���ֶΣ�����ֶ�ֵֻҪ��һ����ƥ������ǲ�ͬ�ļ�¼
select distinct deptno,sal from emp;


--�ڲ�ѯ�Ĺ����п��Ը�����ӱ�����ͬʱҲ���Ը�����ӱ���
select e.empno ��Ա���,e.ename ��Ա����,e.job ��Ա���� from emp e where e.deptno = 10;
--������������Լ�as��Ҳ���Բ��ӣ���������
select e.empno as ��Ա���,e.ename  as ��Ա����,e.job as ��Ա���� from emp e where e.deptno = 10;
--�������������������а����ո���ô��Ҫ�����������á�����������
select e.empno as "��Ա ���",e.ename  as "��Ա ����",e.job as "��Ա ����" from emp e where e.deptno = 10;
--��ѯ���е������ֶ�,����ʹ��*,��������Ŀ��ǧ��Ҫ���ʹ��*,���ױ�����
select * from emp;


/* �������ʽ
��������,<>��<,>,<=,>=,any,some,all
is null,is not null
between x and y
in��list����not in��list��
exists��sub��query��
like  _ ,%,escape ��\��   _\% escape ��\��

*/
-- =
select * from emp where deptno = 20;
--!=
select * from emp where deptno !=20;
--<> ������
select * from emp where deptno <> 20;
--<,
select sal from emp where sal <1500;
-->,
select sal from emp where sal >1500;
--<=,
select sal from emp where sal <=1500;
-->=,
select sal from emp where sal >=1500;
--any,ȡ��������һ��
select sal from emp where sal > any(1000,1500,3000);
--some,some��any��ͬһ��Ч����ֻҪ��������ĳһ��ֵ�������
select sal from emp where sal > some(1000,1500,3000);
--all���������е�ֵ�Ż����
select sal from emp where sal > all(1000,1500,3000);
--is null,��sql���﷨�У�null��ʾһ������ĺ��壬null != null,����ʹ��=����=�жϣ���Ҫʹ��is ,is not
select * from emp where comm is null;
--,is not null
select * from emp where comm is not null;
select * from emp where null is null;
--between x and y,����x��y��ֵ
select * from emp where sal between 1500 and 3000;
select * from emp where sal >=1500 and sal <=3000;
--��Ҫ����ĳЩֵ�ĵ�ֵ�жϵ�ʱ�����ʹ��in��not in
--in��list����
select * from emp where deptno in(10,20);

--and �����ȼ�Ҫ����or������һ��Ҫ��or����ز����ã�����������������ȼ�
select * from emp where deptno = 10 or deptno = 20;

--not in��list��
select * from emp where deptno not in(10,20);
select * from emp where deptno != 10 and deptno !=20;
/*exists��sub��query��,��exists�е��Ӳ�ѯ����ܲ鵽��Ӧ�����ʱ��
��ζ����������
�൱��˫��forѭ��
--����Ҫ��ѯ���ű��Ϊ10��20��Ա����Ҫ��ʹ��existsʵ��
*/
select * from emp where deptno = 10 or deptno = 20;
--ͨ�����ѭ�����淶�ڲ�ѭ��
select *
  from emp e
 where exists (select deptno
          from dept d
         where (d.deptno = 10 or d.deptno = 20)
           and e.deptno = d.deptno)
/*
ģ����ѯ��
like  _ ,%,escape ��\��   _\% escape ��\��

��like������У���Ҫʹ��ռλ������ͨ���
_,ĳ���ַ��������ֽ�����һ��
%�������ַ������������
escape,ʹ��ת���ַ�,�����Լ��涨ת���ַ�

*/
--��ѯ������S��ͷ���û�
select * from emp where ename like('S%')
--��ѯ������S��ͷ�ҵ����ڶ����ַ�ΪT���û�
select * from emp where ename like('S%T_');
select * from emp where ename like('S%T%');
--��ѯ�����д�%���û�
select * from emp where ename like('%\%%') escape('\')

/*
order by�����������
*/
select * from emp order by sal;
select * from emp order by sal desc;
select * from emp order by ename;
select * from emp order by sal desc,ename asc;

--������ʹ�ü����ֶ�
--�ַ������ӷ�,��ѡ|| (mysql��||��ʾor��һ����concat() )
select 'my name is '||ename name from emp;
select concat('my name is ',ename) from emp;
--��������Ա������н
select ename,(e.sal+e.comm)*12 from emp e;

--ͨ�ú��� nvl
--null�ǱȽ�����Ĵ��ڣ�null���κ����㶼����Ϊnull�����Ҫ���ս���ת��
--���뺯��nvl��nvl(arg1,arg2),���arg1�ǿգ���ô����arg2��������ǿգ��򷵻�ԭ����ֵ
select ename,(e.sal+nvl(e.comm,0))*12  from emp e;


--�Լ���ȫ�����������
--A
select * from emp where deptno =30;
--B
select * from emp where sal >1000; 
--�����������������е��������ݶ�������ʾ��ȥ��
select * from emp where deptno =30 union
select * from emp where sal >1000;
--ȫ�������������ϵ�����ȫ����ʾ����ȥ��
select * from emp where deptno =30 union all
select * from emp where sal >1000;
--���������������н�������ݼ���ֻ��ʾһ��
select * from emp where deptno =30 intersect 
select * from emp where sal >1000;
--�,������A���϶���������B�����е����ݣ���A��B�ļ���˳�����
select * from emp where deptno =30 minus 
select * from emp where sal >1000;


--group by,����ĳЩ��ͬ��ֵȥ���з������
--group���з��������ʱ�򣬿���ָ��һ���л��߶���У�
--��ÿ�����ŵ�ƽ��нˮ
select avg(sal) from emp group by deptno;
--��ƽ���������2000�Ĳ���
select avg(sal),deptno from emp where sal is not null group by deptno having avg(sal) >2000 order by avg(sal);

select count(10000) from emp;
--�����¹�Ա�Ĺ���>2000 ����
select deptno,count(1) from emp where sal>2000 group by deptno
--����нˮ���
select deptno,max(sal) from emp group by deptno;
--�������� ������С���������ҳ���,֪������
select deptno,min(hiredate),max(hiredate) from emp group by deptno;
select ename, deptno
  from emp e
 where hiredate in (select min(hiredate) from emp group by deptno)
    or hiredate in (select max(hiredate) from emp group by deptno)
select * from emp

select mm2.deptno, e1.ename, e1.hiredate
  from emp e1,
       (select min(e.hiredate) mind, max(e.hiredate) maxd, e.deptno
          from emp e
         group by e.deptno) mm2
 where (e1.hiredate = mm2.mind
    or e1.hiredate = mm2.maxd)
    and e1.deptno = mm2.deptno;



