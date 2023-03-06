# 一、在MySQL中，创建以下数据表，并使用JDBC连接MySQL数据库。
# 同时，实现数据表的增、删、改、查操作
drop database if exists jdbc_test;
create database if not exists jdbc_test ;
use jdbc_test;
create table `staffs`(
     `id` int(10) primary key auto_increment,
     `name` varchar(24) not null default '' comment '姓名',
     `age` int(10) not null default 0 comment '年龄',
     `phone` char(11) not null default '' comment '联系方式',
     `pos` varchar(20) not null default '' comment '职位',
     `add_time` timestamp not null default current_timestamp comment '入职时间'
) comment '员工记录表';
# 提示：需要自行下载连接MySQL的驱动程序
