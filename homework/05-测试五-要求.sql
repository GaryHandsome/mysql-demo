#### 综合作业
# 一、建库、建表自行阅读文件 "05-测试五-数据.sql"

# 二、综合查询操作
-- 1、 查询student表中的所有记录的sname、ssex和class列。
select sname,ssex,class from student;


-- 2、 查询教师所有的单位即不重复的depart列。
-- 方法一
select distinct depart from teacher;

-- 方法二
select depart from teacher
group by depart;

-- 3、 查询student表的所有记录。
select * from student;

-- 4、 查询score表中成绩在60到80之间的所有记录。
select * from score where degree between 60 and 80;

-- 5、 查询score表中成绩为85，86或88的记录。
select * from score where degree in(85,86,88);

-- 6、 查询student表中“95031”班或性别为“女”的同学记录。
-- 方法一
select * from student where class='95031'
union
select * from student where ssex='女';

-- 方法二
select * from student where class='95031' or ssex='女';

-- 7、 以class降序查询student表的所有记录。
select * from student order by class desc;

-- 8、 以cno升序、degree降序查询score表的所有记录。
select * from score order by cno asc,degree desc;

-- 9、 查询“95031”班的学生人数。
select * from Student;

-- 方法一
select class,count(*) as 人数
from student
where class='95031';

-- 方法二
select class,count(*) as 人数
from student
group by class
having class='95031';


-- 10、查询score表中的最高分的学生学号和课程号。

-- 不严谨
select sno,cno,degree from score
where degree=
(
    select max(degree) from score
);

select sno,cno,degree from score
where degree=
(
  select distinct max(degree) from score
);


-- 11、查询‘3-105’号课程的平均分。
select round(avg(degree),1) from score where cno='3-105';


-- 12、查询score表中至少有5名学生选修的并以3开头的课程的平均分数。
select cno as 课程编号,avg(degree)as 平均分 from score
where cno like '3%'
group by cno
having count(*)>=5;

select t.cno as 课程编号,avg(degree) as 平均分 from
(
    select * from score where cno like '3%'
) as t
group by t.cno
having count(t.sno)>=5 ;


-- 13、查询最低分大于70，最高分小于90的sno列。
select sno from score
group by sno
having min(degree) >70 and max(degree)<90;


-- 14、查询所有学生的sname、cno和degree列。
select sname,cno,degree
from student t1
    left join score t2 on t1.sno=t2.sno;


-- 15、查询所有学生的sno、cname和degree列。
select * from student ;
select * from score ;
select * from course;

select t1.sno,cname,degree from student t1
    inner join score t2 on t1.sno=t2.sno
    inner join course t3 on t2.cno=t3.cno ;

select t1.sno,cname,degree from student t1
    inner join score t2
    inner join course t3
    on t1.sno=t2.sno and t2.cno=t3.cno ;


-- 16、查询所有学生的sname、cname和degree列。
select sname,cname,degree
from student t1
    inner join score t2 on t1.sno=t2.sno
    inner join course t3 on t2.cno=t3.cno ;


-- 17、查询“95033”班所选课程的平均分。
select * from student;
select * from score;

select cno,avg(degree)
from student t1
    inner join score t2 on t1.sno = t2.sno
where class='95033'
group by cno ;

-- 18、假设使用如下命令建立了一个grade表：
create table grade
(
    low int(3),
    upp int(3),
    `rank` char(1)
);

insert into grade values(90,100,'a');
insert into grade values(80,89,'b');
insert into grade values(70,79,'c');
insert into grade values(60,69,'d');
insert into grade values(0,59,'e');
commit;

select * from grade ;

-- 现查询所有同学的sno、cno和rank列。
select * from student ;
select * from score ;
select * from grade ;


select t1.sno,t2.cno,t2.degree,t3.rank from student t1
    inner join score t2 on t1.sno=t2.sno
    inner join grade t3 on t2.degree between t3.low and t3.upp
order by t1.sno ;

-- 19、查询选修“3-105”课程的成绩高于“109”号同学成绩的所有同学的记录。
select * from student ;
select * from score ;

-- 方法一
select * from score
where degree >
(
    select degree from score
    where sno='109' and cno='3-105'
) and cno='3-105';


-- 方法二
select t1.sno,t2.cno,t2.degree
from student t1
    inner join score t2 on t1.sno=t2.sno
where t2.cno='3-105' and degree >
(
    select degree from score
    where sno='109' and cno='3-105'
) ;


-- 20、查询score中选学一门以上课程的同学中分数为非最高分成绩的记录（*）。
-- 第一：查询选修一门以上的课堂的学生
# select sno from score group by sno having count(*)>1 ;
-- 第二：查询某课程最高分的成绩，其中?代表的是传递的某门课程
# select max(degree) from score t2 where ？=t2.cno ;
-- 最终答案
select * from score t1
where t1.sno in (select sno from score group by sno having count(*)>1)
and t1.degree <> (select max(degree) from score t2 where t1.cno=t2.cno) ;


-- 21、查询成绩高于学号为“109”、课程号为“3-105”的成绩的所有记录。
select * from score where cno='3-105';

select * from score where degree >
(
    select degree from score where sno='109' and cno='3-105'
) and cno='3-105' ;




-- 22、查询和学号为108的同学同年出生的所有学生的sno、sname和sbirthday列。
select * from Student;

select sno,sname,date_format(sbirthday,'%Y-%m-%d') from student
where year(sbirthday) =
(
    select year(sbirthday) from student where sno='108'
);


-- 23、查询“张旭“教师任课的学生成绩。
select * from teacher ;
select * from course ;
select * from score ;

select t1.tname,t3.sno,t3.degree from teacher t1
  inner join course t2 on t1.tno=t2.tno
  inner join score t3 on t2.cno=t3.cno
where t1.tname='张旭' ;

-- 24、查询选修某课程的同学人数多于5人的教师姓名。
select * from teacher ;
select * from course ;
select * from score ;

-- 方法一
select tname from teacher where tno in
(
    select tno from course where cno in
    (
        select cno from score
        group by cno
        having count(*)>5
    )
) ;

-- 方法二
select t1.tname,t2.cno,count(*) from teacher t1
    inner join course t2 on t1.tno=t2.tno
    inner join score t3 on t2.cno=t3.cno
group by t2.cno,t1.tname,t1.tno
having count(*)>5;

-- 25、查询95033班和95031班全体学生的记录。
select * from student where class in ('95033','95031');
select * from student where class='95033' or class='95031';


-- 26、查询存在有85分以上成绩的课程cno。
select distinct cno from score where degree>85;

select sc.cno
from score sc
group by sc.cno
having max(degree)>85;


-- 27、查询出“计算机系“教师所教课程的成绩表。
select * from teacher ;
select * from course ;
select * from score ;

select t3.sno,t1.depart,t2.cname,t3.degree from teacher t1
    inner join course t2 on t1.tno = t2.tno
    inner join score t3 on t2.cno = t3.cno
where t1.depart='计算机系';


-- 28、查询“计算机系”与“电子工程系“不同职称的教师的tname和prof（*）。
-- 自连接
select * from teacher;

select t1.tname,t1.prof,t2.tname,t2.prof,t1.depart
from teacher t1
inner join teacher t2 on t1.depart=t2.depart
where  t1.prof<>t2.prof;



-- 29、查询选修编号为“3-105“课程且成绩至少高于选修编号为“3-245”的同学的cno、sno和degree,并按degree从高到低次序排序。
select t1.cno,t1.sno,t1.degree
from score t1
where t1.cno = '3-105' and t1.degree >
(
    -- 至少高于：求最大值；而高于则看下题
    select max(degree)
    from score
    where cno = '3-245'
)
order by t1.degree desc;

-- 30、查询选修编号为“3-105”且成绩高于选修编号为“3-245”课程的同学的cno、sno和degree.
select t1.cno ,t1.sno,t1.degree,t2.cno,t2.sno,t2.degree
from score t1
    inner join score t2 on t1.sno=t2.sno
where t1.cno='3-105' and t2.cno='3-245' and t1.degree>t2.degree
order by t1.degree desc;


-- 31、查询所有教师和同学的name、sex和birthday。
select tname,tsex,tbirthday from teacher
union all
select sname,ssex,sbirthday from student;

-- 32、查询所有“女”教师和“女”同学的name、sex和birthday。
select tname,tsex,tbirthday from teacher where tsex='女'
union all
select sname,ssex,sbirthday from student where ssex='女';


-- 33、查询成绩比该课程平均成绩低的同学的成绩表。
select * from score t1
where t1.degree<
(
    select avg(degree) from score t2
    group by cno
    having t1.cno=t2.cno
);


-- 34、查询所有任课教师的tname和depart。
select tname,depart from teacher;


-- 35  查询所有未讲课的教师的tname和depart。
select * from teacher;
select * from course ;

-- 所有的老师都带课了，可以添加一条老师信息做测试
select t1.tname,t1.depart from teacher t1 left join course t2 on t1.tno=t2.tno
where isnull(t2.tno) ;


-- 36、查询至少有2名男生的班号。
select * from student ;

select class,ssex,count(*)
from student
group by class,ssex
having ssex='男';


-- 37、查询student表中不姓“王”的同学记录。
select * from student where sname not like '王%';
select * from student where sname not regexp '王.*';


-- 38、查询student表中每个学生的姓名和年龄。
select sname as 姓名,ssex as 年龄 from student ;


-- 39、查询student表中最大和最小的sbirthday日期值。
select max(sbirthday),min(sbirthday) from student ;

-- 40、以班号和年龄从大到小的顺序查询student表中的全部记录。
select * from student
order by class desc,sbirthday asc;

-- 41、查询“男”教师及其所上的课程。
select t1.tname,t1.tsex,t2.cname from teacher t1 inner join course t2 on t1.tno=t2.tno
where t1.tsex='男' ;

-- 42、查询最高分同学的sno、cno和degree列。
select sno,cno,degree from score
where degree=
(
    select max(degree) from score
);

-- 43、查询和“李军”同性别的所有同学的sname。
select sname from student where ssex=
(
    select ssex from student where sname='李军'
);

-- 44、查询和“李军”同性别并同班的同学sname。
select sname from student where (ssex,class)=
(
    select ssex ,class from student where sname='李军'
);

-- 45、查询所有选修“计算机导论”课程的“男”同学的成绩表
select * from course;
select * from score ;
select * from student ;

select t2.* from course t1
    inner join score t2 on t1.cno=t2.cno
    inner join student t3 on t2.sno=t3.sno
where t3.ssex='男' and t1.cname='计算机导论';







