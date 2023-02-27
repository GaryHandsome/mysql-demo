-- 1.在学生信息表中，查询学生的信息，
-- 显示的字段为：学号,姓名,性别,出生日期,年龄，要求如下：
-- 年龄要求必须满周岁
select timestampdiff(year,'2021-02-23',now()) as 年龄;
use 学生成绩管理系统;
select * from 学生信息;
select `学号`,`姓名`,`性别`,`出生日期`,timestampdiff(year,`出生日期`,now()) as 年龄
from 学生信息;


-- 2.在学生信息表中，查询所有字段的学生信息，要求如下：
-- 年龄从小到大排列，且只显示前面5个女学生
select * from 学生信息
where 性别='女'
order by 出生日期 desc
    limit 5 ;


-- 3.在学生信息表中，统计陈姓的数量，显示格式为：姓,数量
select * from 学生信息
where 姓名 like '陈%';

select left(姓名,1) as 姓 from 学生信息
where 姓名 like '陈%';

select left(姓名,1) as 姓,count(*) as 数量
from 学生信息
    # where 姓名 like '陈%'
    # 注意：字段的别名不能应用在 where 语句中，但可以用在group by 、having、order by中
    # where 姓='陈'
group by 姓
having 姓='陈';
# order by 姓 ;


-- 4.在成绩信息表中，查询分数在85-90的所有字段信息，
-- 要求如下：
-- 按分数从高到低排序
-- 如果分数相同，则按课程编号从小到大排序
select * from 成绩信息
where 分数 >=85 and 分数 <=90
order by 分数 desc,课程编号*1 asc;

-- 5.在成绩表中，查询各课程的平均分，要求如下：
-- 保留一位小数
select 课程编号,round(avg(分数),1) as 平均数
from 成绩信息
group by 课程编号;

-- 6.在教师信息表中，查询所有字段的教师信息，要求如下：
-- 籍贯带有'西'字
-- 要求使用两种方法实现：模糊查询和正则查询
-- 6.1 模糊查询
-- 6.2 正则查询
select * from 教师信息 where 籍贯 like'%西%';
select * from 教师信息 where 籍贯 regexp '.*西.*';

-- 7.在教师信息表中，查看教师的籍贯都有哪些
select distinct 籍贯 from 教师信息;

-- 8.在成绩信息表中，实现分页查询所有的成绩信息，要求如下：
-- 每页显示8条记录
-- 显示第三页的所有成绩信息
-- (当前页-1) * 每页记录数,每页记录数
select * from 成绩信息 limit 16,8;

-- 9.查看学号编号为：2005010101，课程编号为：1的成绩信息，
-- 显示字段为：学生编号,0801成绩,0802成绩
-- 提示：行转列
select * from 成绩信息;

# 第一：找到要合并分组的字段(学生编号)，如三个张三要合并成一行
select * from 成绩信息
group by 学生编号;

# 第二：找到要行转列的字段(考试编号)，如0801、0802
# 第三：进行判断，输出要展示的数据(score)
#   判断是否为0801、0802，从而输出具体的 分数
# 第四：符合分组查询的要求
select 学生编号,
       max(case 考试编号 when '0801' then 分数 else 0 end) as  '0801成绩',
        max(case 考试编号 when '0802' then 分数 else 0 end) as  '0802成绩'
from 成绩信息
group by 学生编号;

# 第五：根据需求进行过滤
# 查看学号编号为：2005010101，课程编号为：1的成绩信息，
select 学生编号,
       max(case 考试编号 when '0801' then 分数 else 0 end) as  '0801成绩',
        max(case 考试编号 when '0802' then 分数 else 0 end) as  '0802成绩'
from 成绩信息
where 课程编号=1
group by 学生编号
having  学生编号='2005010101' ;
