-- 1.查询学生及其所在班级的信息，显示格式为：学号,姓名,性别,班级名,班级人数
-- 第一：找到数据相关的数据表
select * from `学生信息` ;
select * from `班级信息` ;

-- 第二：连接数据表（主外键 + 连接方式）
select * from `学生信息`
    inner join `班级信息` on `所属班级`= `班级编号`;

-- 第三：筛选数据（查询字段 + 分组 + 条件 + 排序）
select 学号,姓名,性别,班级名,班级人数 from `学生信息`
   inner join `班级信息` on `所属班级`= `班级编号`;

-- 2.查看各系的班级信息，显示的格式为：系别名称,班级名,班级人数
-- 按班级人数降序排序
select * from `系别信息` ;
select * from `班级信息`;

select * from `系别信息`
    inner join `班级信息` on `系别编号` = `所属系别`;

select 系别名称,班级名,班级人数 from `系别信息`
    inner join `班级信息` on `系别编号` = `所属系别`
order by 班级人数 desc ;

-- 3.查询学生所有课程的成绩，显示的格式为：学生编号,考试编号,课程名称,分数
-- 要求：根据学生编号升序排序
select * from `成绩信息` ;
select * from `课程信息` ;

select * from `成绩信息` t1
    inner join `课程信息` t2 on t1.`课程编号`=t2.`课程编号`;

-- 注意：主外键名称相同，则必须给表指定别名，便于引用
select 学生编号,考试编号,课程名称,分数 from `成绩信息` t1
    inner join `课程信息` t2 on t1.`课程编号`=t2.`课程编号`
order by `学生编号` asc ;


-- 4.查询学生所有课程的成绩，显示的格式为：学生编号,考试类型,课程名称,分数
-- 要求：先按学生编号升序排序,后按考试类型升序排序
select * from `成绩信息` ;
select * from `考试安排` ;
select * from `课程信息` ;


select * from `成绩信息` t1
    inner join `考试安排` t2 on t1.考试编号=t2.考试编号
    inner join `课程信息` t3 on t1.`课程编号`= t3.`课程编号`;


select 学生编号,考试类型,课程名称,分数
from `成绩信息` t1
inner join `考试安排` t2 on t1.考试编号=t2.考试编号
inner join `课程信息` t3 on t1.`课程编号`= t3.`课程编号`
order by t1.`学生编号` asc,t2.考试类型 asc ;


-- 5.查看辅导员带班的数量，显示格式为：辅导员编号,辅导员姓名,带班数量
-- 要求：辅导员编号升序排序
select * from `辅导员信息`;
select * from `班级信息` ;

select * from `辅导员信息`
left join `班级信息` on `辅导员编号`=辅导员;

select `辅导员编号`,姓名,count(`班级编号`) as 班级数
from `辅导员信息`
left join `班级信息` on `辅导员编号`=辅导员
group by `辅导员编号`,姓名
order by 辅导员编号 asc;

-- 6.查询与张苗苗同乡的学生信息
-- 要求：使用子查询实现
select `家庭住址` from 学生信息 where 姓名='张苗苗';

select * from 学生信息 where `家庭住址`='河南洛阳';

-- 注意：
-- 子查询使用=(>、>=、<=、<等),
-- 必须保证子查询返回唯一的结果
select * from 学生信息 where `家庭住址`=
(
    select `家庭住址` from 学生信息 where 姓名='张苗苗'
);

-- 严紧一点
select * from 学生信息 where `家庭住址` in
(
    select 家庭住址 from `学生信息` where `姓名`='张苗苗'
);

-- 7.查询成绩没有合格的学生信息
-- 要求：使用子查询实现
select * from 学生信息 where 学号 in
(
    select distinct 学生编号
    from `成绩信息`
    where 分数<60
) ;

-- 8.查询学生的各科的成绩，显示格式为：学号,姓名,考试编号,课程名称,分数
-- 要求：按课程名称升序,考试编号升序,分数降序查询
select * from `成绩信息` ;
select * from `学生信息` ;
select * from `课程信息` ;


select * from `成绩信息` t1
    inner join `学生信息`  t2 on t1.学生编号=t2.学号
    inner join `课程信息` t3 on t1.`课程编号`=t3.`课程编号` ;


select 学号,姓名,考试编号,课程名称,分数
from `成绩信息` t1
inner join `学生信息`  t2 on t1.学生编号=t2.学号
inner join `课程信息` t3 on t1.`课程编号`=t3.`课程编号`
order by t3.`课程名称` asc,t1.`课程编号` asc,t1.`分数` desc ;

-- 9.把老师信息与辅导员信息两张表的数据合并在一张表中，显示的格式为：姓名,性别,年龄,民族,籍贯,联系电话
select 姓名,性别,年龄,民族,籍贯,联系电话 from `教师信息`
union
select 姓名,性别,年龄,民族,籍贯,联系方式 from `辅导员信息`;

-- 注意：子查询可以放在where的后面，也可以放在from的后面
-- 另外，这种情况下，必须指定一个表的别名
select * from
(
    select 姓名,性别,年龄,民族,籍贯,联系电话 from `教师信息`
    union
    select 姓名,性别,年龄,民族,籍贯,联系方式 from `辅导员信息`
) as tbl
where tbl.性别='女' ;

-- 10.统计所有学生的成绩的总分，显示的格式为：学号,姓名,总成绩，要求如下：
-- 根据学号升序排序
-- 如果分数为null，则输出0
select 学号,姓名,ifnull(sum(分数),0) as 总分
from `成绩信息`
right join `学生信息` on 学号=学生编号
group by 学号,姓名
order by 学号 asc ;

