#### 基本查询练习
-- 1.在学生信息表中，查询1985年出生的学生
select * from 学生信息 where 出生日期 like '1985%';
select * from 学生信息 where 出生日期 regexp '1985.*' ;

-- 2.查询姓李的，名只一个字的学生信息
-- 方法一：模糊查询实现
select * from 学生信息 where trim(姓名) like '李_';
-- 方法二：正则实现
select * from 学生信息 where trim(姓名) regexp '^李.?$';

-- 3.查询家庭住址为山东济南,四川成都,湖北武汉的学生信息（要求，1常规写法，in写法）
select * from `学生信息` where 家庭住址='山东济南' or 家庭住址='四川成都' or 家庭住址='湖北武汉' ;
select * from `学生信息` where 家庭住址 in('山东济南','四川成都','湖北武汉') ;

-- 4.查询“张苗苗”在哪个班
/**
	第一：找到查询数据所有的相关表（根据需要，选择关心的字段）
	第二：连接数据表（根据需求，选择不同的连接方式）
	第三：如果两张表无法连接，则需要长到两张表都关联的第三表（中间表）
*/
select * from `学生信息`;
select * from `班级信息`;

-- 区别以下两个查询
select 姓名,班级名 from 学生信息,`班级信息`
where 所属班级=班级编号 and 姓名='张苗苗';

select 姓名,班级名 from 学生信息
    inner join `班级信息` on 所属班级=班级编号
where 姓名='张苗苗' ;

-- 5.查询张苗苗的姓名，性别，民族，出生日期，年龄
-- 方法一
select 姓名,性别,民族,出生日期,year(curdate())-year(出生日期) as 年龄
from `学生信息` where 姓名='张苗苗';

-- 方法二
select 姓名,性别,民族,出生日期,date_format(curdate(),'%Y')-date_format(出生日期,'%Y') as 年龄
from `学生信息` where 姓名='张苗苗';

-- 方法三
select  timestampdiff(year, 出生日期, curdate()) from `学生信息` where 姓名='张苗苗';
select 姓名,性别,民族,出生日期,timestampdiff(year,出生日期,now()) as 年龄
from `学生信息` where 姓名='张苗苗';

-- 6.查询出生日期是1985-1986年的全部学生信息
-- 方法一
select * from `学生信息`
where year(出生日期) between 1985 and 1986 ;

-- 方法二
select * from `学生信息`
where year(出生日期) >= 1985 and year(出生日期)<=1986 ;

-- 方法三
select * from `学生信息`
where 出生日期 regexp '198[56].*';

-- 7.查询外语系的班级名称,班级人数
select * from `系别信息`;
select * from `班级信息`;

select 系别名称,班级名,班级人数
    from `系别信息` inner join `班级信息` on 所属系别=系别编号
where 系别名称='外语系';

-- 8.查询分数是90－95分的学生学号,姓名,性别,分数
select * from `成绩信息`;
select * from `学生信息`;

select 学号,姓名,性别,分数
from `学生信息` inner join `成绩信息` on 学号=学生编号
where 分数 between 90 and 95;

-- 9.查询各个系的编号，系名，学生人数
select * from `系别信息`;
select * from `班级信息`;

select 系别编号,系别名称,sum(班级人数) as 学生人数
from `系别信息` left join `班级信息` on 系别编号=所属系别
group by 系别编号,系别名称;

-- 10.查询各辅导员的带班数量:辅导员编号,辅导员姓名,带班数量
SELECT * FROM `辅导员信息`;
SELECT * FROM `班级信息`;

-- 必须使用左连接且COUNT函数必须使用字段（不能使用*）
select 辅导员编号,姓名,count(班级编号)  as 带班数量
from `辅导员信息` left join `班级信息` on `辅导员编号`=`辅导员`
group by 辅导员编号,姓名;

-- 11.查询各个系的学生总分数:系名称,总分
select * from `系别信息` ;
select * from `班级信息` ;
select * from `学生信息` ;
select * from `成绩信息` ;

select `系别名称`,sum(分数) as 总分 ,round(avg(分数),1) as 平均分
from `系别信息` left join `班级信息` on `系别编号`=`所属系别`
    left join `学生信息` on `班级编号`=`所属班级`
    left join `成绩信息` on `学号`=`学生编号`
group by `系别名称`;

-- 12.查询各个系中，分数最高的学生信息:系名称,学生姓名,课程编号,分数
select 系别名称,姓名,课程编号,班级编号,最高分 from
(
  select * from
      (
          select 系别名称,系别编号,max(分数) as 最高分 from
              (
                  select * from 系别信息,班级信息,学生信息,成绩信息
                  where 系别编号=所属系别 and
                          班级编号=所属班级 and 学生编号=学号
              ) as t1 group by 系别名称,系别编号
      ) as t2 left join 班级信息 on t2.系别编号 = 所属系别
) as tt1 ,
(
  select * from 学生信息,成绩信息 where 学号=学生编号
) as tt2
where tt1.班级编号=tt2.所属班级 and 最高分=tt2.分数;

-- 13.查询课程编号1大于课程编号2的学生信息，要求使用两种方法实现:（自连接、子查询）
select t1.学生编号,t1.课程编号,t1.分数,t2.学生编号,t2.课程编号,t2.分数
from 成绩信息 t1 inner join 成绩信息 t2 on t1.学生编号=t2.学生编号
where t1.分数>t2.分数 and t1.课程编号=1 and t2.课程编号=2;

select * from
    (select 学生编号,课程编号,分数 from 成绩信息 where 课程编号=1) t1 inner join
    (select 学生编号,课程编号,分数 from 成绩信息 where 课程编号=2) t2 on t1.学生编号=t2.学生编号
where t1.分数>t2.分数;

-- 14.查询平均分大于85的学生信息
select * from 学生信息 where 学号 in
 (
     select 学生编号 from 成绩信息
     group by 学生编号
     having avg(分数) > 85
 ) ;

-- 15.查询姓“李”的学生个数
select left(`姓名`,1) as 姓,count(*) as 数量
from 学生信息
-- where left(`姓名`,1)='李'
group by left(`姓名`,1)
having 姓='李';

select '李' as 姓,count(姓名) as 人数 from 学生信息 where 姓名 like '李%'

-- 16.查询各科成绩最高和最低的分：以如下形式显示：课程ID，最高分，最低分
select 课程编号,max(分数) as 最高分,min(分数) as 最低分
from 成绩信息
group by 课程编号
order by 课程编号*1 asc ;
