# 创建数据库
create database aabbcc ;

# 进入指定的数据库
use aabbcc ;

# 创建数据表 - 创建数据表时，使用不同的存储引擎会创建不同类型的文件，用于存储相关的数据
create table if not exists tbl_aa (
  name varchar(50) comment '用户真实姓名'
)engine='MyISAM' charset='utf8';

create table if not exists tbl_bb (
    name varchar(50) comment '用户真实姓名'
)engine='InnoDB' charset='utf8';

# 1.特殊数据类型
##############################################################
#例子三：浮点型数据
CREATE TABLE test3 (
   num1 float(6,2) ,
   num2 double(6,2) ,
   num3 decimal(6,2)
);

insert into test3 values (3.14159,3.14159,3.14159);
insert into test3 values (3.1459,3.1459,3.1459);

# 注意：decimal是以字符串的方式存储的
select * from test3 where num1=3.14;		#查询成功
select * from test3 where num1='3.14';		#查询失败


# 例子四：枚举类型
CREATE TABLE IF NOT EXISTS test4 (
    sex enum('男','女','保密')
);

insert into test4 values ('男  ');	# 空格会自动去除
insert into test4 values ('女');
insert into test4 values ('保密');
-- insert into test4 values ('妖');		# 错误
insert into test4 values (NULL);	# 可以允许为NULL
insert into test4 values (2);	# 通过索引添加，索引顺序为1,2,3

# 例子五：集合类型
CREATE TABLE IF NOT EXISTS test5 (
    sex SET('A','B','C','D')
);
insert into test5 values ('A,D,E');		#错误，值必须在集合范围中，且使用逗号分隔
insert into test5 values ('A,C,D');		#正确
insert into test5 values ('D,B,A');		#正确,添加时数据顺序无关，添加后数据自动排序

# 注意：集合数据以二进制形式存储，即数据A,B,C,D对应的数值为：1,2,4,8。
insert into test5 values (1);			#添加A
insert into test5 values (3);			#添加A、B
insert into test5 values (6);			#添加B、C
insert into test5 values (14);			#添加B、C、D

# 例子六：YEAR类型
CREATE TABLE IF NOT EXISTS test6 (
    birth YEAR
);
# year类型的取值范围是1901-2155
insert into test6 values (1901);
insert into test6 values (2155);
insert into test6 values (50);		#1-69两位数，会加2000，结果为：2050
insert into test6 values (99);		#70-99两位数，会加1900，结果为：1999

insert into test6 values (0);		#0000
insert into test6 values ('0');		#2000
insert into test6 values ('00');	#2000

#例子七：TIME类型 => 时：分：秒
CREATE TABLE IF NOT EXISTS test7 (
    birth TIME
);

insert into test7 values ('1 12:12:12');	#12时12分12秒 + 1天，结果为：36:12:12
insert into test7 values ('12:12');			#12时12分，省略了秒，结果为：12:12:00
insert into test7 values (112233);			#结果为：11:22:33:
insert into test7 values (2233);				#结果为：00:22:33
insert into test7 values (33);					#结果为：00:00:33
insert into test7 values (0);						#结果为：00:00:00
# 注意：小时的取值范围为：-838到838
insert into test7 values ('839:12:12');

# 例子八：DATE类型 => 年-月-日
CREATE TABLE IF NOT EXISTS test8 (
    birth DATE
);
insert into test8 values ('2023-02-22');
insert into test8 values ('12-7-5');		#2012-07-05
insert into test8 values ('80/7/5');		#2012-07-05
insert into test8 values ('12#7$5');		#2012-07-05
insert into test8 values ('120705');		#2012-07-05
insert into test8 values ('19980703');		#1998-07-03

select  * from test8 ;


# 2.约束
##############################################################
# 1）主键
#方法一
CREATE TABLE IF NOT EXISTS user1 (
     id int PRIMARY KEY ,	#主键默认非空
     username varchar(50)
);

#方法二
CREATE TABLE IF NOT EXISTS user1 (
     id int ,				#主键默认非空
     username varchar(50) ,

     PRIMARY KEY(id)
);

#方法三
CREATE TABLE IF NOT EXISTS user1 (
     id int key,				# 省略primary关键字
     username varchar(50)
);

# 复合主键--多个字段共同实现主键
# 使用场景：当一张表中没有任何一个字段能唯一标识记录，这个时候可以考虑组合多个段来唯一标识
CREATE TABLE IF NOT EXISTS user2 (
     id int ,				#主键默认非空
     username varchar(50) ,
     cardNO char(18),

     PRIMARY KEY(id,cardNO)
);

# 自增
# id字段为自动增长，默认的起始值为1，增量为1
CREATE TABLE IF NOT EXISTS user3 (
     id float PRIMARY KEY AUTO_INCREMENT ,			#自动增长必须与主键一起使用
     username varchar(50)
);

insert into user3(username) values ('张三') ;


#指定自动增长的起始值为100
drop table user3;
CREATE TABLE IF NOT EXISTS user3 (
     id int PRIMARY KEY AUTO_INCREMENT ,
     username varchar(50)
) AUTO_INCREMENT=100;														#指定自动增长的起始值

#修改自动增长的值
alter table user3 AUTO_INCREMENT=500;

#添加数据
insert into user3 values (111,'zs') ;	#可以指定自动增长字段数据
insert into user3 values (null,'zs') ;	#可以指定为null或default，该字段会自动增长
insert into user3 values (default,'zs') ;
insert into user3(username) values ('zs') ;	#忽略自动增长字段，该字段会自动增长

select * from user3 ;

-- 删除数据表时，也必须先删除外键表，后删除主键表
drop table tbl_班级信息表 ;
drop table tbl_学生信息表 ;

# 主键表
create table if not exists tbl_班级信息表 (
  班号 char(20) primary key ,
  名称 varchar(20) not null ,
  教室 varchar(20) null
) ;


# 外键表
create table if not exists tbl_学生信息表 (
  学号 varchar(10) primary key ,
  姓名 varchar(50) not null ,
  班级 char(20)  ,
  科目 char(20)  ,
  分数 decimal(4,1) ,

  constraint fk_班级信息表_班级 foreign key(班级)
      references tbl_班级信息表(班号)
      ON DELETE CASCADE
) ;


insert into tbl_班级信息表 values ('186','186Java班','206') ;
insert into tbl_班级信息表 values ('188','188前端班','207') ;


insert into tbl_学生信息表 values ('1001','张三','186','MySQL',90) ;
insert into tbl_学生信息表 values ('1002','李四','186','MySQL',80) ;
insert into tbl_学生信息表 values ('1003','王五','188','MySQL',70) ;

# 错误，因为不存在189这个班级 - 主外键约束能保留数据的完整性和安全性 - 性能
insert into tbl_学生信息表 values ('1004','赵六','189','MySQL',60) ;

# 错误
delete from tbl_班级信息表 where 班号='186' ;

# 解决方法一：先删除外键表对象的数据，然后再删除主键数据
delete from tbl_学生信息表 where 班级='186';
delete from tbl_班级信息表 where 班号='186' ;

# 解决方法二：创建级联删除外键 - 不建议

select * from tbl_班级信息表;
select * from tbl_学生信息表;


CREATE TABLE test2 (
   num1 tinyint zerofill,
   num2 smallint zerofill,
   num3 mediumint zerofill,
   num4 int zerofill,
   num5 bigint zerofill
);

insert into test2 values (1,1,1,1,1);

select * from test2 ;

desc test2 ;

show columns from test2;







