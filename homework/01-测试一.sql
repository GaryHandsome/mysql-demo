create database test01 ;

use test01 ;

# 用户信息
create table if not exists user
(
    user_id bigint primary key auto_increment ,
    user_name varchar(50) unique not null,
    user_pwd varchar(50) not null,
    full_name varchar(50) comment '真实姓名',
    question varchar(50) not null ,
    answer varchar(50) not null,
    sex varchar(50) default '男' check ( sex in ('男','女') ) not null,
    birthday date ,
    email varchar(50) not null,
    phone char(11) ,
    image varchar(50),
    reg_time datetime default now(),
    status int default 1 check ( status in (1,0) )
);

# 栏目信息
create table columns(
    column_id int primary key auto_increment,
    column_name varchar(50) not null ,
    remark varchar(50) ,
    status bit not null default 1
) auto_increment=10000;

# 新闻信息
create table news(
    news_id bigint primary key auto_increment,
    news_title varchar(50) not null,
    news_content text not null,
    news_author varchar(50) not null,
    columns_id int,
    constraint fk_news_columns_id foreign key(columns_id) references columns(column_id) ,
    news_date datetime default now(),
    browse_count int default 0,
    is_top bit default 0,
    status bit default 0
);

# 评论信息
create table comment(
  comment_id bigint primary key auto_increment  ,
  user_id bigint not null,
  news_id bigint not null,
  comment_content text not null ,
  comment_time datetime,
  status bit
);

# 修改评论信息，添加外键
alter table comment add constraint fk_comment_user_id
    foreign key(user_id) references user(user_id);
alter table comment add constraint fk_comment_news_id
    foreign key(news_id) references news(news_id);

# 3）把性别为男且为禁用状态的用户删除
delete from user
       where sex = '男' and status = 0;

# 4）修改某个用户的真实姓名为：张三三，性别为女，电话为自己的电话
update user set
    full_name='张三三' ,
    sex = '女',
    phone='13417747371'
where user_name='sansan' ;

# 5)新闻默认是禁用不发布状态，把张三三发布的所有新闻修改为发布可用状态
update news set
    status = 1
where news_author='sansan' ;

# 6）清空评论信息表的所有数据
delete from comment ;

truncate table comment ;


