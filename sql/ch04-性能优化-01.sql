# 思考：为什么根据 emp_no 字段查询数据那么快呢？
# emp_no是主键，在创建表时，自创建主键索引
# 根据主键查找数据时，触发了索引机制，因此查询速度快
select * from employees where emp_no=10001;

desc employees;

# 创建索引之前，以下查询花费的时间为：162 ms
select * from employees where first_name='Sachin';

# 针对 first_name 字段，创建索引
# create [unique] index 索引名称 on 表名 (字段|字段列表) ;
create index idx_employees_first_name
    on employees (first_name) ;

# 创建索引之后，以下查询花费的时间为：37 ms
select * from employees where first_name='Sachin';


# 索引相关的操作
# 1.查看数据表中所有的索引信息
# 语法：show index from 表名;
show index from employees;

# 2.删除索引
# 语法：drop index 索引名称 on 表名 ;
drop index idx_employees_first_name on employees ;


# 思考：
# 1）是否需要给数据表添加相关的索引呢？
# 2）给哪个字段或哪些字段添加索引？

# 结合性能分析工具以及业务进行判断
# 一、查看执行频次：查看当前数据库的 INSERT, UPDATE, DELETE, SELECT 访问频次

# GLOBAL关键字表示全局系统变量，SESSION关键字表示会话系统变量，如果不指定关键字，默认就是会话系统变量。
# 语法：show [global | session] status like 'com_______';
show global status like 'com_______';

# 观察增、删、改、查的访问次数，
# 如果发现查询的次数远远大于增、删、改的次数，
# 则需要考虑添加索引进行SQL优化
# 思考：如果需要优化，那么，我们需要对哪个查询语句进行优化呢？ - 慢查询日志


# 二、慢查询日志 - 把查询很慢(参数指定)的SQL语句，存储在日志文件中，
# 便于DBA、运维人员、开发者发现，进而进行相关的优化
# 1.查看慢查询日志是否开启 - 默认没有开启
show variables like 'slow_query_log';

# 2、查看慢查询相关的参数
show variables like '%query%';
# ● long_query_time：慢查询时间，默认是10秒
# ● slow_query_log：慢查询开启状态，默认没有开启
# ● slow_query_log_file：慢查询日志文件位置，默认是安装目录下/data/计算机名称-slow.log

# 3、配置慢查询
/*
第一：编辑配置文件 - my.ini

第二：配置如下参数
# 1)慢日志路径
slow_query_log_file=E:\java\mysql-8.0.23-winx64\logs\localhost-slow.log
注意：日志文件的目录必须存在，否则开启失败

# 2)开启慢查询日志开关
slow_query_log=1

# 3)设置慢查询日志的时间为2秒，SQL语句执行时间超过2秒，就会视为慢查询，记录慢查询日志
long_query_time=2

# 第三：重启MySQL

# 第四：测试
select * from titles,employees limit 200000000,10;
*/


# 三、profile - 查看 SQL 语句时间都耗费在哪里
# 1.查询是否支持 - 通过 have_profiling 变量，查看当前 MySQL 是否支持
select @@have_profiling;

# 2.查看是否开启
select @@profiling;

# 3.开启 profile 功能
set profiling=1;

# 4.查看所有语句的耗时
show profiles;

# 5.根据 query_id 查看具体某个查询的详情
# show profile for query query_id;
show profile for query 93;

# 6.查看指定query_id的SQL语句CPU的使用情况
# 语法： show profile cpu for query query_id;
show profile cpu for query 93;

# 4.执行计划 - 模拟优化器执行SQL查询语句，并返回相关的信息，
# 程序员根据返回的信息判断是否进行优化或优化是否成功
# 语法：desc | explain SQL查询语句 ;


# 创建数据库
CREATE DATABASE if not exists explaintest DEFAULT character set = utf8 ;
use explaintest ;

# 用户信息表
CREATE TABLE userinfo
(
    `id` int  ,
    `username` varchar(50)  ,
    `password` varchar(50) ,
    `sex` char(2),
    `age` tinyint
);

INSERT into userinfo (id,username,password,sex,age) VALUES (1001,'zs','111111','男',18) ;
INSERT into userinfo (id,username,password,sex,age) VALUES (1002,'ls','222222','女',28) ;
INSERT into userinfo (id,username,password,sex,age) VALUES (1003,'ww','333333','男',38) ;


# 订单信息表
CREATE TABLE orderinfo
(
    `id` int  ,
    `total` DECIMAL(10,1)  ,
    `date` datetime,
    `userid` int
);

INSERT into orderinfo(id,total,date,userid) values (11,55.4,'2022-02-21 11:11:11.111',1001) ;
INSERT into orderinfo(id,total,date,userid) values (12,100,'2022-02-22 22:22:22.222',1002) ;
INSERT into orderinfo(id,total,date,userid) values (13,136.6,'2022-02-23 12:12:12.122',1003) ;


# 地址信息表
create TABLE address
(
    `id` int  ,
    `detail` varchar(100)  ,
    `isdefault` bool,
    `userid` int
);

insert into address(id,detail,isdefault,userid) values (21,'广东珠海',1,1001) ;
insert into address(id,detail,isdefault,userid) values (22,'广东广州',1,1002) ;
insert into address(id,detail,isdefault,userid) values (23,'广东中山',1,1003) ;
insert into address(id,detail,isdefault,userid) values (24,'广东深圳',0,1003) ;




explain select * from userinfo;

/*
    执行计划返回的信息有以下内容：

    ● id：编号，表的读取和加载顺序
    ● select_type：查询类型
    ● table：表
    ● type：类型
    ● possible_keys：预测可能用到的索引，一个或多个
    ● key：实际使用的索引，如果为NULL，则表示没有使用索引
    ● key_len：实际使用索引的长度
    ● ref：表之间的引用
    ● rows：通过索引查询到的数据量
    ● filtered：表示返回结果的行数占需读取行数的百分比，filtered的值越大越好
    ● Extra：额外的信息
 */

##################
# id字段
# 案例一：id值相同，数据表按顺序查询
select * from userinfo;
select * from orderinfo;
select * from address;

# id值相同：从上往下的顺序执行
explain
    select * from userinfo t1,orderinfo t2 ,address t3
        where t1.id=t2.userid
          and t1.id = t3.userid;


# 案例二（特例）：表的执行顺序会因表数量的改变而改变
# 在userinfo表，添加三条新的数据，再执行以上同样的测试
insert into userinfo (id,username,password,sex,age) values (1004,'zl','444444','女',31) ;
insert into userinfo (id,username,password,sex,age) values (1005,'tq','555555','女',21) ;
insert into userinfo (id,username,password,sex,age) values (1006,'sb','666666','男',22) ;


explain select * from userinfo t1,orderinfo t2 ,address t3
        where t1.id=t2.userid and t1.id = t3.userid;


# id值不同:子查询，从大到小的顺序执行
# 案例三：id值不同（嵌套子查询）
explain
select * from orderinfo t1
where t1.userid =
(
  select t2.id from userinfo t2 where t2.id=
  (
      select t3.userid from address t3 where id=23
  )
);


# 案例四：id值同时存在相同和不相同
explain
select * from orderinfo t1 ,userinfo t2
where t1.userid = t2.id and t1.userid=
(
    select t3.userid from address t3 where id=23
);


##################
# type字段
# null > system > const > eq_ref> ref > range > index > ALL
explain select '你好';

explain
select * from employees where emp_no='10001';

show index from employees ;


##################
# Extra字段 - 额外信息
# Using filesort:文件内排序
# Using temporary：使用了临时表保存中间结果，临时表対系统性能损耗很大。
# Using index：使用了覆盖索引

# 覆盖索引：查询的字段覆盖了索引字段，也就是查询的都是索引字段。
# select 字段1,字段2,... from 表;

# 聚焦索引（主键索引）
# 编号为主键，默认创建主键索引
# 各节点存储有序的编号，在叶子节点中存储对应的整行数据
# 因此，根据编号（主键）查询数据比较快！
select * from 用户信息 where 编号=18 ;


# 在表中，以帐号这个字段创建索引，则帐号就是索引字段
# 以下查询，引用了 覆盖索引 查询，效率也是比较高的
select 编号,帐号 from 用户信息 where 帐号='赵六' ;

# 以下查询，并没有引用 覆盖索引 查询，效率比较低
select 编号,帐号,性别 from 用户信息 where 帐号='赵六' ;
select * from 用户信息 where 帐号='赵六' ;

# 因此，在开发中，select 后面不要跟 *，而且建议使用 覆盖索引 查询






