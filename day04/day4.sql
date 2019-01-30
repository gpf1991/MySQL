insert into acct_trans_detail values
('20180101000002', now(), '622345000002', 1, 200000),
('20180101000003', now(), '622345000003', 1, 400000);


-- 连接查询
select a.acct_no, a.acct_name,
       c.tel_no
from acct a, customer c -- 未作条件关联,得到笛卡尔集
where a.cust_no = c.cust_no; -- 连接条件

select a.acct_no, a.acct_name, c.tel_no
	  from acct a 
	  right join customer c
	  on a.cust_no = c.cust_no;