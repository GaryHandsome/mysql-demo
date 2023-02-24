###############################
# 多表查询 & 子查询
###############################

/*
    如果我们要查询的数据分布在不同的表时，那么需要连接多张表进行多表查询

    操作思路：
    第一：找到数据所在表

    第二：把这些相关的表连接起来
        连接方式：内连接、外连接、自连接、交叉连接
        连接时，一般通过主外键进行连接
        如果连接的两张表中，没有主键外，也没有相关可以连接的字段，此时，很有可能需要第三张表

    第三：筛选数据 - 结合基本查询
 */
use 学生成绩管理系统;

select * from 学生信息;
select * from 成绩信息;

# 1、等值查询
/*
    select 字段集合 from 表1,表2,...,表n
    where 条件 (主外键)
 */

# 需求：学号,姓名,性别,课程编号,分数
# 第一：找到数据所在表 - 学生信息，成绩信息

#第二：把这些相关的表连接起来 - 等值连接
select * from 学生信息,成绩信息 where 学号=学生编号;

# 第三：筛选数据 - 结合基本查询
select 学号,姓名,性别,课程编号,分数
from 学生信息,成绩信息
where 学号=学生编号 and 性别='男'
order by 分数 desc
limit 5;


# 2、内连接查询
-- 功能同等值连接
-- 好处：连接条件与筛选条件分离，简洁明了
/*
    select 字段集合 from 表1 [inner]
        join 表2 on 连接条件(主外键|相同数据类型)
    where 筛选条件
 */
select 学号,姓名,性别,课程编号,分数 from 学生信息
        join 成绩信息 on 学号=学生编号
where 性别='男'
order by 分数 desc
limit 5;

# 3、外连接
create table 老师表
(
    编号 int auto_increment primary key not null ,
    姓名 char(30) ,
    性别 char(2) check(性别='男' or 性别='女') default '男',
    专业 char(30)
);


create table 学生表
(
    学号 int auto_increment primary key not null ,
    姓名 char(30) ,
    性别 char(2) check(性别='男' or 性别='女') default '男',
    身高 float ,
    学分 float ,
    教师编号 int
);




insert into 老师表(姓名,性别,专业) values ('张三','男','计算机');
insert into 老师表(姓名,性别,专业) values ('李四','男','日语');
insert into 老师表(姓名,性别,专业) values ('王五','女','英语');


insert into 学生表(姓名,性别,身高,学分,教师编号)
values ('学生一','男',1.5,50,1);

insert into 学生表(姓名,性别,身高,学分,教师编号)
values ('学生二','女',2.5,60,1);

insert into 学生表(姓名,性别,身高,学分,教师编号)
values ('学生三','男',3.5,70,2);

insert into 学生表(姓名,性别,身高,学分,教师编号)
values ('学生四','女',4.5,80,2);

select * from 教师表;
select * from 学生表;
# 3.1、左外连接
# select 字段集合 from 表1 left [outer] join 表2 on 条件
# 需求：查询各个老师，以及老师所带的学生 - 着重点在于“各个老师”
# 以左表为基础，查询左表全部的数据，然后再连接右表
# 如果能连接，那么就正常连接
# 如果不能连接（无数据），则右表以 null 值表示

# 好处：能保证其中一张表的数据全部查询出来

select * from 教师表 left join 学生表 on 编号=教师编号;


# 3.1、右外连接
# select 字段集合 from 表1 right [outer] join 表2 on 条件
select * from 学生表 right join 教师表 on 编号=教师编号;

# 3.1、完全外连接
# 注意：在MySQL中，不支持full实现完全外连接
# 解决：union
# select 字段集合 from 表1 full [outer] join 表2 on 条件




