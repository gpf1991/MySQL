课程：MySQL关系型数据库
进度：day3

上次内容回顾
1. 数据修改
  update acct 
     set balance = balance + 100,
                  status = 2
   where acct_no = '622345000001';

2. 删除数据
   delete from acct where acct_no = '622345000001';

3. 运算符操作
  1）数值比较：>,<,>=,<=,<>或!=
  2）逻辑运算符
    - and: 多个条件同时满足
    - or：多个条件中只需一个成立

  3）范围比较
    - in: 在某个集合范围内容
    - not in: 不在某个范围
    - between...and...: 数值比较，在...到...

  4）模糊查询
    - 格式：where name like 'D%';

  5）空/非空
    - is null: 判断是否为空
    - is not null: 判断非空

4. 查询子句：排序、分组、筛选
  1）order by: 排序
  2）limit: 限定显示的行数
    - limit n: 表示只显示前面n行
    - limit m, n: 第m笔数据开始，显示n笔

  3）聚合函数：max,min,sum,count,avg

  4）group by: 分组
    select acct_type, count(*)
      from acct
      group by acct_type;

  5）having: 对group by子句的结果进行过滤

  6）distinct: 去重

5. 表结构调整
  alter table 表名 add 字段名称 [first | after 字段]

  修改字段类型
  alter table 表名 modify 字段名 类型

  修改字段名称
  alter table 表名 change 旧字段名 新字段名 类型

  删除字段
  alter table drop 字段名

作业

今天的内容
1. 约束：数据规则（重点）
2. 索引：提高查询效率（重点）
3. 数据导入、导出
4. 表的复制、重命名

1. 约束（constraint）
  1）约束：数据遵循的规则，为了保证数据
          完整性、一致性、有效性

  2）约束类型
    - 非空约束：字段值不能为空
    - 唯一约束：字段值不能重复
    - 主键约束：指定字段作为主键，非空、唯一
    - 默认值：未填写值的情况下，自动填默认值
    - 自动增加：字段的值自动增加
    - 外键约束：某个属性，在当前表不是主键
                在另一个表里是主键
		参照外键时，外键对应的实体必须存在

  3）非空约束(not null)
    - 指定字段的值不能为空，如果插入时没有设置值
      并且没有默认值，插入就会报错
    - 语法：字段名称 字段类型 not null
    - 示例：
	create table customer (
	    cust_no varchar(32) not null,
	    cust_name varchar(128) not null,
	    tel_no varchar(32) not null
	);
	-- 插入数据,tel_no字段违反非空约束
	insert into customer(cust_no, cust_name)
	values('C0001', 'Jerry');

  4）唯一约束(unique)
    - 字段的值不能重复
    - 语法：字段名称  类型 unique
    - 示例
        create table customer (
	    cust_no varchar(32) unique,-- 唯一约束
	    cust_name varchar(128) not null,
	    tel_no varchar(32) not null
	);
	-- 插入重复数据, 违反唯一性约束
	insert into customer
	values('C0001', 'Jerry', '13512345678');
	insert into customer
	values('C0001', 'Tom', '13212345678');
    
  5）主键约束(Primary Key, 简写PK)
    - PK用来唯一标识一笔记录，要求非空、唯一
      PK和一笔记录之间有唯一对应关系
      PK可以是一个字段构成，也可以多个属性共同构成

    - 语法：字段名称 字段类型 Primary Key
    - 示例
	create table customer (
	  cust_no varchar(32) primary key,-- 主键
	  cust_name varchar(128) not null,
	  tel_no varchar(32) not null
	);
	insert into customer
	values('C0001', 'Jerry', '13512345678');

	insert into customer -- 违反非空约束
	values(null, 'Jerry', '13512345678');

	insert into customer -- 违反唯一性约束
	values('C0001', 'Jerry', '13512345678');

  6）默认值
    - 当插入数据时，该字段如果没有填值
      系统会自动填写默认值
    - 语法：字段名称 类型 default 默认值
    - 示例：
      alter table customer add status int default 0;
      -- tel_no未插入,则自动填默认值
      insert into customer
      (cust_no, cust_name, tel_no)
      values('C0002', 'Tom', '13233445566');

  7）自动增长
    - 当字段设置为自动增长时，插入数据不需要填值，
      数据库系统会自动在上一个值上面增加1
      经常和PK配合使用
    - 语法：字段名 字段类型 auto_increment
    - 示例
      create table ai_test(
        id int primary key auto_increment,
	name varchar(32)
      );
      insert into ai_test values(null, 'aaa');-- id=1
      insert into ai_test values(null, 'bbb');-- id=2
      insert into ai_test values(null, 'ccc');-- id=3

  8）外键（难点, 非重点）
    - 外键：在当前表不是主键，另一个表的主键
    - 作用：保证参照的完整性、一致性
    - 使用外键的条件
      表的存储引擎必须为InnoDB
      被参照字段在另外的表里必须是主键
      当前表中的字段类型和被参照的表中类型一致
    - 语法：
      constraint foreign key(当前表字段)
      references 参照表名(参照字段名称)
    - 示例
	create table account(
	  acct_no varchar(32) primary key,
	  cust_no varchar(32) not null,
	  -- 在当前表的cust_no上添加外键约束
	  -- 参照customer表的cust_no字段
	  constraint foreign key(cust_no)
	  references customer(cust_no) 
	);
	-- 插入customer表中存在的客户
	-- 参照完整性正确,可以插入
	insert into account values('0001','C0001');
	-- C0004客户不存在, 参照完整性错误
	-- 插入时报错
	insert into account valuse('0002','C0004');

	-- 删除被参照的值, 也会报错
	-- C0001客户在account表中被参照使用
	delete from customer where cust_no='C0001';

	-- 删除外键
	alter table 表名 drop foreign key 外键名

2. 索引（重点）
  1）索引(Index)
    - 是一种提高查询效率的技术，相当于书的目录
    - 包含着记录的引用的指针，根据引用指针快速
      找到数据存放的位置
    - 通过避免全表扫描，来提高查询效率

  2）索引类别
    - 普通索引、唯一索引
    - 单列索引、组合索引

  3）如何创建索引
    - 创建表时候创建索引
      语法:字段名 字段类型 [index|unique|primary key]
           index    普通索引
	   unique   唯一索引
	   primary key   主键，自动成为唯一索引

      示例1：创建账户交易明细表，并在交易流水号
             上创建唯一索引
      create table acct_trans_detail (
	  trans_sn  varchar(32) not null, -- 交易流水号
	  trans_date datetime not null, -- 交易时间
	  acct_no varchar(32) not null, -- 交易账号
	  trans_type int , -- 交易类型
			   -- 存款, 取款, 刷卡, 结息
	  amt decimal(16,2) not null, -- 交易金额
	  unique(trans_sn),   -- 在trans_sn上创建唯一索引
	  index(trans_date)   -- 在trans_date上建立普通索引
	);

	-- 查看索引
	show index from acct_trans_detail;

	-- 插入数据
	insert into acct_trans_detail
	values('201801010001',now(),'622345000001',1,1000);

	-- 查询时使用索引字段作为条件, 就会使用到索引
	select * from acct_trans_detail
	where trans_sn = '201801010001';

      - 通过修改表的方式创建索引
        create 索引类型 索引名称 on 表名(字段名)
	alter table 表名 add 索引类型 索引名称(字段)

	create index trans_date on 
	acct_trans_detail(trans_date);

	alter table acct_trans_detail
	add unique index trans_sn(trans_sn);
  
      - 删除索引
        drop index 索引名称 on 表名
	e.g. drop index trans_date on acct_trans_detail

  4）索引优缺点
    - 优点
      提高查询效率
      唯一索引能够保证数据的唯一性
      在使用索引字段分组、排序时，效率会提高
    - 缺点
      需要额外的存储空间
      创建和维护索引需要额外的时间
      降低增、删、改的效率

  5）索引使用原则
    - 使用恰当的索引
    - 索引并不是越多越好，索引太多影响增删改效率

    - 适合使用索引的情况
      字段经常作为查询条件
      字段的值相对均匀、连续
      如果某个字段经常用来作为排序依据，适合加索引

    - 不适合使用索引的情况
      不经常作为查询条件
      值太少的字段不适合建索引(性别、账户状态)
      数据量太少不适合建立索引
      二进制类型的数据字段不适合建索引
    - 主键、唯一索引效率很高

3. 数据导入导出
  1）导出
    - 格式
      select查询语句
      into outfile '文件路径'
      fields terminated by '字段分隔符'
      lines terminated by '行分隔符'
    - 示例：
      第一步：查看数据库允许导出的目录路径
        show variables like 'secure_file%'
	secure_file_priv: /var/lib/mysql-files/

      第二步：执行导出（导出到第一步所看到的目录下）
        select * from acct
	into outfile '/var/lib/mysql-files/acct.bak'
        fields terminated by ','
	lines terminated by '\n';

      第三步：查看导出的文件
        sudo cat /var/lib/mysql-files/acct.bak

  2）导入
    - 格式
      load data infile '备份文件路径'
      into table 表名称
      fields terminated by '字段分隔符'
      lines terminated by '行分隔符';
    - 示例
      load data infile '/var/lib/mysql-files/acct.bak'
      into table acct
      fields terminated by ','  -- 指定字段分割符
      lines terminated by '\n'; -- 指定行分隔符

4. 表的复制、重命名
  1）复制
    - 将源表完全复制为新表(包含表结构、数据)
      create table acct_new
      select * from acct;

      拷贝部分数据
      create table acct_new
      select * from acct where balance<2000;

      只拷贝表结构
      create table acct_new
      select * from acct where 1=0;
     *注意：这种方式复制表，不会把键属性复制过来

  2）重命名
    - 格式：alter table 表名 rename to 新表名
    - 示例：alter table acct rename to acct_new;

课堂练习（eshop库中进行如下操作）
1. 修改orders表结构
  1）在order_id列上添加主键约束
  2）在cust_id, order_date, products_num字段上
     添加非空约束
  3）在status字段上添加默认值，默认值为1
  4）在order_date上添加普通索引
2. 创建客户信息表(customers)，包含字段有
  cust_id	客户编号，字符串，32位，主键
  cust_tel	客户电话，字符串，32位，非空
  cust_name	客户姓名，字符串，64位，非空
  address	送货地址，字符串，128位，非空
3. 为customers表添加数据，要求每个orders表中的
   cust_id都有对应的客户信息
4. 在orders表的cust_id上创建外键约束
  参照customers表的cust_id字段





