-- 第三天作业
-- 1. 调整orders表的结构
-- 1)order_id上添加主键约束
alter table orders add primary key(order_id);

-- 2)cust_id,order_date,products_num添加非空约束
alter table orders 
modify cust_id varchar(32) not null;

alter table orders
modify order_date datetime not null;

alter table orders 
modify products_num int not null;

-- 3)将status字段默认值设为1
alter table orders
modify status enum('1','2','3','4','5','6','9')
default 1;

-- 4)order_date字段创建普通索引
create index idx_order_date on orders(order_date);

-- 2. 创建orders表, cust_id作为逐渐,其它字段非空约束
create table customers (
  cust_id varchar(32) primary key,
  cust_tel varchar(32) not null,
  cust_name varchar(64) not null,
  address varchar(128) not null
) charset=utf8;

-- 3. 
insert into customers values
('0001', '13512345678', 'Jerry', '北京'),
('0002', '13522334455', 'Tom', '成都'),
('0003', '13111112222', 'Dekie', '杭州');

-- 4. orders表cust_id上添加外键
--    参照customers表的cust_id字段
alter table orders 
add constraint foreign key(cust_id)
references customers(cust_id); 