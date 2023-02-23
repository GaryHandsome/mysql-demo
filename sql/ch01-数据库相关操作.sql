-- 1.创建数据库
# 注释
/*注释*/
create database if not exists pms
    default character set = 'UTF8';

-- 2.删除数据库
drop schema if exists pms;

-- 3.查看当前服务器下的数据库列表
# 语法：show databases | schemas ;
show databases;

-- 4.查看指定数据库的定义
show create database pms;

-- 5.修改指定数据库的编码方式
#语法：alter database | schema 数据库名称 [default] character set [=] 字符集名称;
alter database pms
    default character set = 'utf8';


-- 6、打开指定数据库
# 语法：use 数据库名;
use pms;

# 查看当前打开的数据库，如果没打开则显示null
# 语法：select database() | schema() ;
select database();

-- 7、查看上一步操作产生的警告信息
show warnings ;