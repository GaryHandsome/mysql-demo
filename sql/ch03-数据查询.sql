# 建议
select 100 / 2 ;

# 了解
select 100 div 2 ;

select 100 > 200;


# 1.查询所有字段的数据
# * 表示所有字段，但是在开发中坚决不能使用，影响查询性能。
# 一般在测试的时候使用
select * from 学生信息;


# 2.局部字段查询 - select 字段1,字段2,... from 表名
# 注意：在开发中，必须使用局部查询，能触发索引机制，提高查询效率
# 否则扣工资
select 学号,姓名,性别,民族,所属班级,家庭住址
from 学生信息;

# 3.查询前面N条数据  - select * from 表名 limit N ;
# 注意：MySQL不支持 top N 语法 - 使用 limit 实现
# select top 5 * from 学生信息 ;
select * from 学生信息 limit 5;

# 4.条件查询 - select * from 表名 where 条件
# 注意：条件一般结合逻辑运算和关系运算进行操作
select * from 学生信息
where 性别='女' and 家庭住址='江西南昌';

# 5.between and 的使用
select * from 成绩信息;
select * from 成绩信息
         where 分数 >= 98 and 分数<=100;

select * from 成绩信息
    where 分数 between 98 and 100;

# 6.is null / is not null 的使用
update 辅导员信息 set
    籍贯=NULL
where 辅导员编号='09' ;

select * from 辅导员信息
where 籍贯 is not null ;

# 7.in / not in 的使用
select * from 学生信息;

select * from 学生信息
    where 家庭住址='河南商丘'
    or 家庭住址='江西南昌'
    or 家庭住址='贵州贵阳' ;

select * from 学生信息
where 家庭住址 not in ('河南商丘','江西南昌','贵州贵阳') ;


# 8.like-模糊查询的使用
# 注意：like查询必须结合通配符使用
# _ : 匹配任意的一个字符
# % : 匹配任意的零个或多个字符
# [] ：MySQL不支持
select * from 学生信息;

select * from 学生信息 where 家庭住址 like '河南%';
select * from 学生信息 where 姓名 like '%丽_';

# MySQL不支持[]，使用 regexp 替换实现
select * from 学生信息
where 出生日期 like '198[5-8]%' ;

select * from 学生信息
where 出生日期 regexp '198[5-8].*' ;

# 9.别名 as
# 注意：别名只是临时修改而已，并不影响原来的名称
# 9.1）给字段指定别名 - 如：DBUtil
select 姓名,所属班级 as 班级编号 from 学生信息;

# 9.2）给表名指定别名 - 常用于多表查询，区分不同表的同名字段
select stu.学号,stu.姓名 from 学生信息 as stu;

# 10.字符连接 +
# MySQL的 + 号很单纯，只进行算术运算，不存在字符串连接
# 如果需要字符串连接，可以使用连接字符串的函数，concat
select 1 + 1 ;
select 1 + '1' ;
select 1 + '你' ;

select concat(1,'你',true,'好','好好学习') as '合并';


# 11.排序
# - order by 字段1 asc | desc , 字段2 asc | desc ,...
# 注意：默认是 asc（升序）
select * from 成绩信息
order by 分数 desc ;

# 多字段排序
# 注意数据类型问题
select * from 成绩信息
order by 分数 desc , 成绩编号*1 desc;


# 12.聚合函数
# 注意：聚合函数一般结合分组查询一起使用
/*
    max():最大值
    min():最小值
    sum()：求和
    avg()：求平均数
    count()：统计数量
        count(*) - 统计全表总记录数
        count(字段) - 忽略Null数据，建议使用主键
 */

select * from 辅导员信息;

select count(*) from 辅导员信息;
select count(辅导员编号) from 辅导员信息;

select count(籍贯) from 辅导员信息;

select sum(分数) as 总分,
    avg(分数) as 平均分,
    min(分数) as 最低分,
    max(分数) as 最高分,
    count(学生编号) as 人数
from 成绩信息;

# 13.分组查询 - 难点 - group by 字段
# 原理：把分组字段中，相同的数据划分为同一组
# 分组查询一般结合聚合函数使用 - 先分组，后统计(聚合函数)
# 注意：分组查询后，select 查询的内容必须满足以下两个条件:
# 第一：要么是分组字段
# 第二：要么字段使用聚合函数

select 性别,count(学号) as 人数 from 学生信息
group by 性别
having 性别='女' ;

# where 分组之前条件 - where用于普通查询条件
# having 分组之后条件 - having一定是结合分组查询使用
select 性别,count(学号) as 人数 from 学生信息
    where 性别='女'
group by 性别 ;

-- with rollup ： 分组汇总
select 性别,count(学号) as 人数 from 学生信息
group by 性别
with rollup ;

select coalesce(null,'我好') ;

# 改进 - 统计和汇总
select coalesce(性别,'总人数') as 名称,
       count(学号) as 人数
from 学生信息 group by 性别
with rollup ;

# 14.distinct - 去重
# 14.1）针对一个字段进行去重
select distinct 民族 from 学生信息;

# 14.2）针对多个字段进行去重
select distinct 性别,民族 from 学生信息;

# 15.分页查询
# select * from 表名 limit (当前页-1) * 每页记录数,每页记录数
select * from 学生信息 limit 0,3;
/*
public List<Product> queryAllByPager(int cp,int pageCount) {

    String sql = "select * from 学生信息 limit ?,?" ;

    psmt.setInt(1, (cp-1) * pageCount) ;
    pstmt.setInt(2,pageCount) ;
}
*/

# 16.case when的使用
CREATE TABLE test_user
(
    id int primary key auto_increment ,
    name varchar(50) not null ,
    gender tinyint default 1 ,
    country_code smallint
) engine=InnoDb default charset=utf8;

insert into test_user(name,gender,country_code) values ('清风',1,100) ;
insert into test_user(name,gender,country_code) values ('玄武',2,100) ;
insert into test_user(name,gender,country_code) values ('Kobe',1,110) ;
insert into test_user(name,gender,country_code) values ('John Snow',1,200) ;

select  * from test_user;

select id,name,gender,
       (
           case gender
               when 1 then '男'
               when 2 then '女'
               else '未知'
               end
           ) as 性别,
       country_code
from test_user;

# 17.行转列
create table grade
(
    id int(10) not null auto_increment ,
    user_name varchar(20),
    course varchar(20),
    score float ,
    primary key(id)
) engine=InnoDb default charset=utf8 ;

insert into grade(user_name,course,score) values ('张三','数学',34) ;
insert into grade(user_name,course,score) values ('张三','语文',58) ;
insert into grade(user_name,course,score) values ('张三','英语',58) ;
insert into grade(user_name,course,score) values ('李四','数学',45) ;
insert into grade(user_name,course,score) values ('李四','语文',87) ;
insert into grade(user_name,course,score) values ('李四','英语',45) ;
insert into grade(user_name,course,score) values ('王五','数学',76) ;
insert into grade(user_name,course,score) values ('王五','语文',34) ;
insert into grade(user_name,course,score) values ('王五','英语',89) ;

select * from grade;

SELECT user_name,
       max(case course when '数学' then score else 0 end) 数学,
       max(case course when '语文' then score else 0 end) 语文,
       max(case course when '英语' then score else 0 end) 英语
from grade
GROUP BY user_name
having user_name='张三' ;

/*
要点：
  第一：找到要合并分组的字段(user_name)，如三个张三要合并成一行
  第二：找到要行转列的字段(course)，如语文、数学、英语
  第三：进行判断，输出要展示的数据(score)
      判断是否为语文、数学、英语，从而输出具体的score
  第四：符合分组查询的要求
  第五：根据需求进行过滤
*/





