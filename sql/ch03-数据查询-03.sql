###############################
# 子查询
###############################
/*
    概念：一条查询语句中被嵌套到另一条完整的查询语句中，其中被嵌套的查询语句，称之为子查询或内查询

    语法：
        select * from 表
            where ... ( select ... ) ;

    子查询的位置：select、from、where、having

    分类：
        1）单行子查询：子查询的结果只有一行
            一般结合单行操作符使用：>、<、=、 <>、 >=、 <=

        2）多行子查询：子查询的结果有多行
            一般结合多行操作符使用：some、any、all、in、not in
 */
use 学生成绩管理系统;
select * from 学生信息;

-- 查询与张苗苗同一个地方的学生，要求：使用子查询实现

-- 第一：先查询 张苗苗 的家庭住址
select 家庭住址 from 学生信息 where 学号='2005010102';

-- 第二：根据 张苗苗 的家庭住址，查询同一个地方的学生
select * from 学生信息 where 家庭住址 = '河南洛阳' ;

-- 第三：合并查询
-- 子查询 - 返回单行单列
select * from 学生信息 where 家庭住址 = (select 家庭住址 from 学生信息 where 学号='2005010102') ;

-- 子查询：单行多列
select * from 学生信息 where (家庭住址,性别) = ('河南洛阳','女') ;

select 家庭住址,性别 from 学生信息 where 学号 = '2005010102';

select * from 学生信息 where (家庭住址,性别) =
(
    select 家庭住址,性别
    from 学生信息
    where 学号='2005010102'
) ;


-- 子查询 - 返回多行单列
select * from 学生信息;
select * from 成绩信息;

-- 需求：查询某个班级（20050101）所有学生的成绩，使用子查询操作

select 学号 from 学生信息 where 所属班级='20050101';

select * from 成绩信息 where 学生编号 in ('2005010101','2005010102') ;

select * from 成绩信息
where 学生编号 in
(
    select 学号 from 学生信息
    where 所属班级='20050101'
) ;


/*
    some、any、all -了解

    1）any与some相同，对子查询的结果进行逻辑或运算。
    也就是说，只要满足其中一个条件即可。
    比如：子查询返回三个数据，分别为：a、b、c
    select * ... where 字段 >any (a,b,c)
    select * ... where 字段 >a or 字段>b or 字段>c

    2）＝any 或 =some 等同于 in
    比如：子查询返回三个数据，分别为：a、b、c
    select * ... where 字段 =any (a,b,c)
    select * ... where 字段 =a or 字段=b or 字段=c
    select * ... where 字段 in (a,b,c) ;

    注意：=any 或 =some 后面必须要是子查询，不能是具体某些数据；
    而in语句后面可以是子查询，也可以是具体的某些数据
    select * from 学生信息;

    select * from 学生信息
    where 家庭住址 in ('河南商丘','河南洛阳','河南安阳') ;

    -- 查询年龄大于38岁同学的地址
    select 家庭住址 from 学生信息
    where year(now())-year(出生日期)>38

    -- 查询与大于38岁同学同一个地方的学生信息
    select * from 学生信息
    where 家庭住址 in (select 家庭住址 from 学生信息
    where year(now())-year(出生日期)>38) ;

    -- some、any、all后面必须跟子查询，而不能是具体数据
    select * from 学生信息
    where 家庭住址 =some ('河南商丘','河南洛阳','河南安阳') ;

    select * from 学生信息
    where 家庭住址 =some (select 家庭住址 from 学生信息
    where year(now())-year(出生日期)>38) ;

    3）而All则对子查询的结果进行逻辑与运算；
    也就是说，必须满足所有的条件才可以。
    比如：子查询返回三个数据，分别为：a、b、c
    select * ... where 字段 >all (a,b,c)
    select * ... where 字段>a and 字段>b and 字段>c
*/


/*
    -- 判断子查询是否有查询结果，有返回true，否则返回false
    ... where [NOT] EXISTS (子查询)
*/

select * from 学生信息
where exists
(
    select * from 成绩信息
) ;

select * from 学生信息
where not exists
(
  select * from 成绩信息 where 分数>200
) ;


/**
  子查询常用在select语句，同时也可以用在insert、update、delete语句中。
*/

select * from 学生信息;

select 性别 from 学生信息 where 学号='2005010102';

select * from 学生表;

select 性别 from 学生表 where 学号=2;

update 学生信息 set
    性别 = (select 性别 from 学生表 where 学号=2)
where 姓名='李家洋';

-- 删除年龄大于38岁的学生
delete from 学生信息 where 学号 in
(
    select 学号 from 学生信息
    where year(now())-year(出生日期) > 38
) ;
-- 注意：经测试，子查询应用在insert、update、delete时，
-- 不同操作同一张表

-- select 学号 from 学生信息 where year(now())-year(出生日期) > 38

/**
  函数（略） - 查文档 - ? 函数名称
  在开发中，使用程序本身的API方法，而不建议使用数据库的函数

 */
select substring('quadratically',5,2);