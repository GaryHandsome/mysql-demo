##################
# 准备数据
create table `staffs`(
    `id` int(10) primary key auto_increment,
    `name` varchar(24) not null default '' comment '姓名',
    `age` int(10) not null default 0 comment '年龄',
    `phone` char(11) not null default '' comment '联系方式',
    `pos` varchar(20) not null default '' comment '职位',
    `add_time` timestamp not null default current_timestamp comment '入职时间'
) comment '员工记录表';

insert into `staffs`(`name`,`age`,`phone`,`pos`) values
('rose',18,'13417740001','dev'),
('lucy',19,'13417740002','dev'),
('lily',17,'13417740003','dev'),
('petter',16,'13417740004','dev'),
('preusig',15,'13417740005','dev'),
('zielinski',13,'13417740006','dev'),
('kalloufi',14,'13417740007','dev'),
('peac',16,'13417740008','dev'),
('piveteau',29,'13417740009','dev'),
('sluis',16,'13417740010','dev'),
('bridgland',18,'13417740011','dev'),
('terkki',21,'13417740012','dev'),
('genin',20,'13417740013','dev'),
('nooteboom',12,'13417740014','dev'),
('cappelletti',14,'13417740015','dev'),
('bouloucos',13,'13417740016','dev'),
('peha',14,'13417740017','dev'),
('haddadi',15,'13417740018','dev'),
('warwick',16,'13417740019','dev');

# 创建复合索引
create index idx_staffs_name_age_pos
    on staffs(`name`,`age`,`pos`);

# 查看数据表索引信息
show index from staffs;

##################
# 索引使用规则
# 1.最佳左前缀法则
# 用到了idx_staffs_name_age_pos索引中的name字段 - key_len=74
explain select * from `staffs` where `name` = 'rose';

# 用到了idx_staffs_name_age_pos索引中的name, age字段 key_len=78
explain select * from `staffs` where `name` = 'ringo' and `age` = 18;

# 用到了idx_staffs_name_age_pos索引中的name，age，pos字段，这是属于全值匹配的情况！！！
# key_len=140
explain select * from `staffs` where `name` = 'ringo' and `age` = 18 and `pos` = 'manager';

# 同上，正常的使用了复合索引，条件顺序无关
explain select * from `staffs` where `age` = 18 and `pos` = 'manager' and `name` = 'ringo' ;

# 索引没用上，all全表扫描
explain select * from `staffs` where `age` = 18 and `pos` = 'manager';

# 索引没用上，all全表扫描
explain select * from `staffs` where `pos` = 'manager';

# 用到了idx_staffs_name_age_pos索引中的name字段，pos字段索引失效
explain select * from `staffs`
                 where `name` = 'ringo'
                   and `pos` = 'manager';


##################
# 2.索引字段不要进行计算
# 现在要查询`name` = 'rose'的记录下面有两种方式来查询！

# 1）直接使用 字段 = 值的方式来计算
explain select * from `staffs` where `name` = 'rose';


# 2、使用MySQL内置的函数
explain select * from `staffs` where left(`name`, 5) = 'rose';


##################
# 3.范围之后全失效
# 用到了idx_staffs_name_age_pos索引中的name，age，pos字段 这是属于全值匹配的情况！！！
explain select * from `staffs` where `name` = 'ringo' and `age` = 18 and `pos` = 'manager';


# 用到了idx_staffs_name_age_pos索引中的name，age字段，pos字段索引失效
explain select * from `staffs` where `name` = '张三' and `age` > 18 and `pos` = 'dev';

# 解决：在业务允许的情况下，加上“=”
explain select * from `staffs` where `name` = '张三' and `age` >= 18 and `pos` = 'dev';

##################
# 3.覆盖索引尽量用
# 只访问索引的查询，索引列和查询列一致，减少SELECT *。
select * from staffs ;
show index from staffs ;

# 尽量查询 索引字段 - 覆盖索引
select id,name,age,pos from staffs ;

# 如果查询了非索引字段，如下面的 phone ，则需要进行 回表查询
select id,name,age,pos,phone from staffs ;

# 因此，在开发中不要使用 * 查询字段数据
select * from staffs ;


#########
# 测试案例
show index from staffs ;

drop index idx_staffs_name_age_pos on staffs;


# 聚集索引，叶子节点直接返回整行数据
explain select * from `staffs` where id=1;

# 给name字段，创建索引
create index idx_staffs_name on staffs(name);

# 使用了覆盖索引 -- extra:using index
explain select id,name from staffs where name='rose';

# 没有使用覆盖索引 -- extra:null
# 其中，phone字段没有定义索引
explain select id,name,phone from staffs where name='rose';

# 以下也没有使用覆盖索引，*包含了其它非索引字段 -- 必定会进行回表查询，从而影响性能
explain select * from staffs where name='rose';














