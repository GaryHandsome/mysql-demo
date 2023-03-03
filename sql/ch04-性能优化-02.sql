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
# 4.覆盖索引尽量用
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

##################
# 5.like百分加右边
# 通配符 % 不能写在开始位置，否则索引失效。

show index from staffs ;

# 索引失效 全表扫描
explain select * from `staffs` where `name` like '%ing%';

# 索引失效 全表扫描
explain select * from `staffs` where `name` like '%ing';

# 使用索引范围查询 - 开发中，在业务允许的情况下，%放在右边
explain select * from `staffs` where `name` like 'rin%';


# 如果在业务一定要使用 %like ，而且还要保证索引不失效，那么使用覆盖索引来编写SQL。
# 使用到了覆盖索引
explain select `id` from `staffs` where `name` like '%in%';

explain select `id`,name from `staffs` where `name` like '%in%';

explain select `id`,name,age from `staffs` where `name` like '%in%';


##################
# 6.字符要加单引号
# 字段串类型的索引字段，在使用时必须加引号，否则索引失效
# 符合最左法则，部分使用了索引
explain select * from `staffs` where `name` = '2000';

# 字符串类型字段不加引号，索引失效
# 这里name = 2000在mysql中会发生强制类型转换，将数字转成字符串。
explain select * from `staffs` where `name` = 2000;

# 以下查询是否走索引 - 走部分索引字段,pos索引字段失效
explain select * from `staffs`
                 where `name` = 'ringo'
                   and `age` = 18
                   and `pos` = 1000;

##################
# 7.or连接的条件
# 使用or分割的条件中，如果or前的条件中字段有索引，
# 而后面的字段中没有索引，那么涉及的索引都不会被用到。

# 其中，id字段有主键索引，add_time字段没有定义索引
# 解决：给add_time字段添加索引
show index  from staffs;
drop index idx_staffs_add_time on staffs;
create index idx_staffs_add_time on staffs(add_time) ;

explain select * from `staffs`
                 where id=1 or add_time='2021-03-01';


create index idx_name_age_pos on staffs(name,age,pos) ;

# 索引失效，全表查询，or的右边也必须遵循最左原则
explain select * from `staffs` where id=1 or age=20;
# 索引生效
explain select * from `staffs` where id=1 or name='李四';

##################
# 8.数据分布影响
# 如果 MySQL 评估使用索引比全表查询更慢，则不使用索引。

# 全表查询
explain select * from staffs where phone>='13417740000';

# 给phone字段添加索引
create index idx_staffs_phone on staffs(phone);

# 再次测试，发现仍然是全表查询，并没有使用到索引
# 原因：当满足条件时，相当于查询全表，mysql认为查询全表比按索引查询更快
explain select * from staffs where phone>='13417740000';

# 修改条件再测试，满足条件只是部分数据，进索引更快
explain select * from staffs where phone>='13417740009';


# 思考，执行以下sql语句，是否走索引？
explain select * from `staffs` where `phone` != '13417740001';

# 删除数据，再测试
delete from staffs where phone>='13417740004'

### 思考：目前为止，当我们执行查询语句时，有没有指定调用哪个索引？


##################
# 9.SQL提示，是优化数据库的一个重要手段。
# 简单的说，就是在SQL语句中加入一些人为的来达到优化操作的目的。
# ● use index：使用某个索引，但 MySQL 不一定使用
# ● ignore index：忽略某个索引
# ● force index：强制使用某个索引

# 语法
# select 字段集合 from 表名 use index(索引名称) where 条件 ;
# select 字段集合 from 表名 ignore index(索引名称) where 条件 ;
# select 字段集合 from 表名 force index(索引名称) where 条件 ;


show index from staffs;
drop index idx_staffs_phone on staffs;

# 创建单列索引
create index idx_staffs_name on `staffs`(`name`);

# 测试，可能用到的索引有：idx_staffs_name_age_pos、idx_staffs_name
# 最终，mysql选择了idx_staffs_name_age_pos
# 如果我们想使用idx_staffs_name索引，怎么办呢？
explain select * from `staffs` where name='lucy';


# 使用指定的索引
explain select * from `staffs` use index(idx_staffs_name)
                 where name='lucy';

# 忽略某个索引
explain select * from `staffs`
    ignore index(idx_name_age_pos)
where name='lucy';

# 强制使用某个索引
explain select * from `staffs` force index(idx_staffs_name)
                 where name='lucy';


##################
# 10.前缀索引
# 当字段类型为字符串时，字符串的长度可能很大，
# 创建索引时，如果都使用全部字符串来创建，
# 则索引会很大，查询时，浪费大量的IO，
# 从而影响查询效率。
# 因此，我们可以截取字符串的一小部分作为前缀，
# 用于创建索引，这样可以大大节约索引空间，从而提高索引效率。

# 新闻信息表 - 新闻内容( text )

select * from staffs;

# 查看某个字段的 选择性 - 1
select count(distinct(name)) / count(*) from staffs ;

select count(distinct(left(name,3))) / count(*) from staffs ;


# 使用某个字段一部分数据进行索引的创建 - 此字段是长字符串数据
create index idx_staffs_sub_name on staffs (name(3)) ;

show index from staffs ;


explain select * from `staffs`
                 use index(idx_staffs_sub_name)
                 where name='lucy';



