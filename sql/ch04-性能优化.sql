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