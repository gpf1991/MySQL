# insert.py
# pymysql的插入示例
import pymysql 
from db_conf import * #导入配置

try:        
    conn = pymysql.connect(host, user, \
                   password, dbname)  #连接数据库 
    cursor = conn.cursor()  #获取游标
    #执行SQL语句
    sql = '''insert into 
      acct(acct_no, acct_name, cust_no, 
           acct_type, reg_date, status, balance)
      values('622345000010','Robert', 'C0010',
           1, date(now()), 1, 33.00)'''    
    print(sql)
    cursor.execute(sql) #执行
    conn.commit() #提交事务
    print("Insert OK")
except Exception as e:
    print("数据库插入异常")
    print(e)
finally:
    cursor.close() #关闭游标
    conn.close() #关闭连接