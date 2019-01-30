# query.py
# pymysql查询示例
import pymysql
from db_conf import * #导入配置

#建立到数据库服务器的连接，创建连接对象
conn = pymysql.connect(host, user, \
               password, dbname)               

#创建游标对象(cursor)，通过调用数据库连接
#对象获得游标
cursor = conn.cursor()

#利用cursor对象，执行SQL语句
sql = "select * from acct"
cursor.execute(sql)  #执行SQL语句

#取出查询结果,并打印
result = cursor.fetchall() #result是元组
for r in result: #遍历result
    acct_no = r[0] #账号
    acct_name = r[1] #户名
    if r[6]: #判断是否为空值
        balance = float(r[6]) #余额
    else:
        balance = 0.00 #余额为空设置为0
    print("账号:%s, 户名:%s, 余额:%.2f" % \
         (acct_no, acct_name, balance))
#关闭游标对象
cursor.close()
#关闭数据库连接对象
conn.close()