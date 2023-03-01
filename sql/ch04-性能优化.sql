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
*/


