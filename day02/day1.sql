-- day1.sql
-- MySQL第一天的SQL语句

-- 创建表acct(账户)
create table acct (
    acct_no varchar(32),
    acct_name varchar(128)
) default charset=utf8;

-- 删除 
drop table acct;

-- 重新创建acct
create table acct(
  acct_no varchar(32),-- 账号,字符串,32字节
  acct_name varchar(128),-- 户名,128字节
  cust_no varchar(32), -- 客户编号
  acct_type int, -- 账户类型,整数型
  reg_date  date, -- 开户日期, 日期类型
  status int,    -- 账户状态,整数型
  balance decimal(16,2) -- 数字类型
                        -- 最长16位,2位小数
) default charset=utf8;

-- 插入
insert into acct 
values('622345000001', 'Jerry', 'C0001',
       1, now(), 1, 1000.00);

-- 插入多笔数据
insert into acct values
('622345000006','Michile','C0006',1,now(),1,7000.00),
('622345000007','David','C0007',1,now(),1,8000.00),
('622345000008','Mike','C0008',1,now(),1,5500.00);

-- 指定字段插入
insert into acct(acct_no, acct_name)
values('622345000005', 'Emma');

-- 查询
select * from acct;

-- 指定字段查询
select acct_no, acct_name, balance from acct;

-- 查询指定字段, 并且为字段起别名
select acct_no "账号",-- 双引号中间为别名
       acct_name "户名", 
       balance "余额"
from acct;
-- 或者
select acct_no as "账号" from acct;

-- 查询时,利用字段值进行计算
select acct_no "账号",-- 双引号中间为别名
       acct_name "户名", 
       balance / 10000 "余额(万元)"
from acct;

-- 带条件的查询
select * from acct
where acct_no = '622345000001';

-- 带两个条件的查询, 两个条件同时满足
select * from acct
where acct_no = '622345000001'
  and acct_name = 'Jerry';

-- 带两个条件的查询, 两个条件满足一个
select acct_no, acct_name, balance
from acct 
where acct_name = 'Jerry'
   or acct_name = 'Tom';

-- char和varchar类型示例
create table tmp (
    acct_no  char(10),
    acct_name varchar(32)
);
insert into tmp values('0001', 'Jerry');

-- enum, set类型
create table enum_test(
    name varchar(32),
    sex enum('boy','girl'),-- 从两者选一
    course set('music', 'dance','paint')
);
-- 在枚举范围内,可以插入
insert into enum_test 
values('Jerry', 'girl','music,dance');
-- 在枚举范围之外,插入报错,football不在范围内
insert into enum_test 
values('Jerry', 'girl','music,football');
