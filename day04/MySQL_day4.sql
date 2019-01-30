课程：MySQL关系型数据库
进度：day4

上次内容回顾
1. 约束(constraint)
  1）数据库层级对数据添加的规则
     维护数据一致性、完整性、正确性
  2）类型：非空、唯一性、主键、默认值、自动增加、
           外键约束

2. 索引
  1）提高查询效率的技术，通过避免全表扫描
     提高查询效率
  2）优缺点
    - 优点：提高查询效率
    - 缺点：增加额外的存储空间，降低增删改的效率

  3）索引使用注意事项
    - 使用恰当的索引，并不是越多越好
    - 适合使用索引的情况
      经常查询的字段
      数据相对较为连续、均匀的字段适合建索引
      经常用于排序的字段适合建立索引
    - 不适合建立索引的情况
      经常不查询的字段不适合建立索引
      字段的值较少，不适合建立索引
      表的数据量很小，不适合建立索引
      二进制格式的字段，不适合建立索引

3. 导入导出
  导出：select * from 表名
        into outfile '文件路径' -- secure_file_priv
	fields terminated by '字段分隔符'
	lines terminated by '行分隔符'

  导入：load data infile '文件路径'
        into table '表名'
	fields terminated by '字段分隔符'
	lines terminated by '行分隔符'

4. 表的复制、重命名
  1）create table 表名称 查询语句
  2）alter table 原表名称 rename to 新表名称

作业
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

今天的内容
1. 子查询（一个查询中，包含另一个查询）（重点）
2. 连接查询（两个/多个表查询返回一个结果）（重点）
3. 权限管理
4. 数据库事务（重点）

1. 子查询
  1）什么是子查询：查询语句中包含另外一个查询
     也叫嵌套查询
     例如：查询发生过交易的账户信息
      select * from acct where acct_no in ( -- 外层
        select distinct acct_no from acct_trans_detail
      )

      说明：括号中的部分称之为子查询
            先执行子查询，返回一个结果集
	    再执行外层查询
	    子查询返回的结果，要和外层查询的条件匹配
	    子查询只执行一次

  2）什么情况下使用子查询
     - 一个查询语句无法实现
     - 一个查询语句实现不方便、不直观

  3）单表子查询
     - 示例：查询所有余额大于平均余额的账户
     select * from acct 
     where balance > (select avg(balance) from acct)
     等价于：
     select * from acct
     where balance > 5214.285714;

  4）多表子查询
    - 示例1：查询所有发生过交易的账户信息
    select * from acct where acct_no in (
      select distinct acct_no from acct_trans_detail
    );
    
    - 示例2：查询所有未发生过交易的账户信息
    select * from acct where acct_no not in (
      select distinct acct_no from acct_trans_detail
    )

    - 示例3：查询所有发生过大金额交易的账户信息
             先通过子查询查询出发生10万以上交易
	     的账户，再通过外层查询查账户信息
    select * from acct where acct_no in (
      select distinct acct_no 
        from acct_trans_detail
       where amt > 100000
    )

2. 连接查询（联合查询）
  1）笛卡尔积
    - 定义：两个集合乘积，每个集合中元素两两组合
            产生的新集合
    - 意义：表示两个集合所有可能的情况组合
       A：学生集合     B：课程集合
       A和B的笛卡尔积表示所有学生可能的选课情况

       A：所有声母     B：所有韵母
       A和B的笛卡尔积表示所有可能的拼音组合
    - 笛卡尔积和关系（二维表）：
      笛卡尔集中可能含有不存在（没有实际意义）数据
      去掉这部分数据就是关系
      例如：bun在汉语拼音中不存在，应该去掉

  2）连接查询
    - 什么是连接查询：将两个（或以上）的表连接起来
          得到一个新表（可以叫表的连接）
    - 什么时候使用连接查询：当从一个表中无法获得
         所有想要的数据时候，使用联合查询
	 （前提是两个表数据有关联关系）
    - 示例：
    -- 连接查询
	select a.acct_no, a.acct_name,
	       c.tel_no
	from acct a, customer c -- a,c为表的别名
	where a.cust_no = c.cust_no; -- 连接条件
	
	* 通过字段关联，如果关联到数据则显示
	  如果未关联到数据，则不显示
	  这种连接查询称之为内连接

  3）连接分类
    - 内连接：关联到的数据显示，没有关联到数据不显示
      格式：select 字段列表 from 表A
            inner join 表B
	    on 关联条件
      示例：select a.acct_no, a.acct_name, c.tel_no
              from acct a 
	     inner join customer c
	     on a.cust_no = c.cust_no;

    - 外连接：没有关联到的数据也显示
             （指定哪个表的数据全部显示）
      左连接：左表为主，左表内容全部显示，右表匹配
      左连接格式：
         select 字段列表 from 表A
	 left join 表B
	 on 关联条件
      示例：查询账户、户名、客户电话，如果账户对应
            的客户不存在，也要显示账户、户名
	 select a.acct_no, a.acct_name, c.tel_no
	  from acct a 
	  left join customer c
	  on a.cust_no = c.cust_no;

      右连接：右表为主，右表内容全部显示，左表匹配
      右连接格式：
         select 字段列表 from 表A
	 right join 表B
	 on 关联条件
      示例：      
	 select a.acct_no, a.acct_name, c.tel_no
	  from acct a 
	  right join customer c
	  on a.cust_no = c.cust_no;

3. 权限管理（难点）
  1）权限：用户可以进行哪些操作
  2）分类：
    - 用户类：创建用户、删除用户、给用户授权
    - 库操作：创建库、删除库
    - 表操作：创建表、删除表
    - 数据操作：增、删、改、查
  3）权限表
    - user: 最重要的权限表，记录了允许连接到服务器
            的用户及具有的权限
    - db: 记录库的授权信息
    - tables_priv: 记录表的授权信息
    - columns_priv: 记录字段的授权信息

  5）授权
    - 语法：
      grant 权限列表 on 库名称.表名称
      to '用户名'@'客户端地址'
      [identified by '密码']
      [with grant option]

    - 说明：
      权限列表：被授权用户拥有哪些权限
         all privileges: 所有权限
	 select, insert, update, delete: 分别制定权限
    
    - 库名称.表名
         *.*		表示所有库、所有表
	 bank.*		表示bank库下所有表
	 bank.acct	特指bank库下的acct表

    - 客户端地址
         %		表示所有客户端
	 localhost	表示本机
	 192.168.1.5	表示制定192.168.1.5这台机器


    - 示例：
      示例1：给Daniel用户授予所有库、
             所有表的所有权限，所有客户端都能访问
	     并且将密码设置为'123456'
	     允许该用户向其他用户授权
	 grant all privileges on *.*
	 to 'Daniel'@'%'
	 identified by '123456'
	 with grant option;

	 执行成功后，重新加载权限设置生效：
	 flush privileges

	 重新Daniel用户登录验证：
	 mysql -uDaniel -p123456

      示例2：给Tom用户授权，能对所有库、所有表
             进行查询，限定只能从本机登录
	     并将密码设置为'123456'
	  grant select on *.*
	  to 'Tom'@'localhost'
	  identified by '123456';

	  执行成功，刷新权限，查询user表中Tom用户设置
	  
	  重新用Tom用户登录，执行查询(成功)
          执行插入（拒绝）、建表（拒绝）
      
      课堂练习：
          给用户Jerry授权，只能访问bank库下的表
	  能够对该库的所有表增、删、改、查
	  (insert, delete, update, select)
	  可以从任意客户端登录

	  grant insert,delete,update,select
	  on bank.* 
	  to 'Jerry'@'%'
	  identified by '123456';

	  执行成功后，刷新权限，然后查看：
	  select * from db where user = 'Jerry'\G;

	  验证bank库下的插入、查询、删除、修改权限
          验证访问其他库的权限

     - 查看自己的权限：show grants
     - 查看其他用户权限(用户权限足够)：
         show grants for 'Tom'@'localhost';

   6）吊销权限
     - 语法：revoke 权限列表 on 库名.表名
             from '用户'@'客户端地址'

     - 示例：吊销Jerry用户bank库下的delete权限
         revoke delete on bank.* 
	 from 'Jerry'@'%'

4. 数据库事务（重点）
  1）什么是事务(Transaction)：数据库的一系列操作
     要么全都执行，要么全都不执行

  2）作用：保证数据一致性、正确性
     例如：0001 向 0002 账户转1000元钱
           0001  减去1000元
	   0002  加上1000元

	   以上两个操作，要么全都执行，要么全都不执行
  
  3）使用事务的场景
    - 对数据进行修改
    - 如果修改成功，则提交事务，所有的修改都被保存
      失败，则回滚，所有的修改都被撤销
  
  4）MySQL中，启用事务的表必须是InnoDB存储引擎

  5）事务特征：ACID特性
    - 原子性(Atomicity)
      事务是一个整体，要么全都执行，要么全都不执行
    - 一致性(Consistency)
      事务执行完成后，从一个一致性状态
      变成另一个一致性状态
    - 隔离性(Isolation)
      事务之间不相互影响、干扰
    - 持久性(Durability)
      事务一旦提交，对数据库的修改就必须持久保存

  6）MySQL中操作事务
    - 启动：start transaction
    - 提交：commit
    - 回滚：rollback

    示例：利用事务控制转账操作
    第一步：开始事务
      start transaction;
    第二步：修改转出账户余额
      update acct set balance = balance - 100
        where acct_no = '622345000001';
    第三步：修改转入账户余额
      update acct set balance = balance + 100
        where acct_no = '622345000002';
    第四步：提交事务
      commit;
    第一次，四个步骤全部执行
    第二次，执行前两个步骤，然后rollback回滚
            第二步修改的数据会被取消
	    在回滚之前，新登录一个客户端查询数据
      
课堂练习：
使用eshop库，完成如下操作：
1. 利用子查询，查询所有订单状态为"申请退货"的
   客户的名称、电话号码
2. 利用连接查询，查询"待送货"订单的信息
   查询结果包含的字段有：
   订单编号 下单时间 客户编号 客户电话 送货地址
3. 创建eshop_admin用户，并授权：
  1）eshop库所有表、所有权限
  2）允许从任意客户端登录
  3）设置密码
4. 创建eshop_user用户，并授权：
  1）eshop库中所有表的查询权限
  2）允许从任意客户端登录
  3）设置密码








