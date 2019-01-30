-- 创建orders表
create table orders(
    order_id varchar(32),
    cust_id varchar(32),
    order_date datetime,
    status enum('1','2','3','4','5','6','9'),
    products_num int,
    amt decimal(16,2)
) default charset=utf8;

-- 插入数据
insert into orders values
('201801010001','0001',now(),'1',2,100),
('201801010002','0001',now(),'1',1,200),
('201801010003','0002',now(),'4',1,70),
('201801020001','0002',now(),'2',3,200),
('201801020002','0003',now(),'3',4,200);

-- 查询语句
select * from orders where status = '1';

select * from orders 
where status in('3','4','5');

select * from orders
where cust_id = '0002' 
and status = '2';

select order_date, status
from orders
where order_id = '201801020001';

select * from orders
where cust_id = '0001'
order by order_date desc;

select status "状态", count(*) "笔数"
from orders
group by status;

select max(amt), min(amt),
       avg(amt), sum(amt)
from orders;

select * from orders 
order by amt desc
limit 3;

alter table orders add invoice int;
alter table orders add invoice_date datetime;

update orders 
   set status = '4'
 where order_id = '201801020001';

delete from orders where status = '9';