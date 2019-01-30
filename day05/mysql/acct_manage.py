# acct_manage.py
# 账户管理系统, 实现账户增删改差
import pymysql
from db_conf import *

db_conn = None  #连接对象

def conn_database(): #连接数据库
    global db_conn
    db_conn = pymysql.connect(host, user,\
            password, dbname)
    if not db_conn: # 连接失败
        print("连接数据库失败")
        return -1
    else:  # 连接成功
        return 0

def close_database(): #关闭数据库连接
    global db_conn
    if db_conn:  # 判断对象不为空
        db_conn.close()

def login_acct():
    userid = input('请输入用户名:')
    pwd = input('请输入密码:')
    sql = '''select * from user_pwd''' 

    global db_conn
    cursor = db_conn.cursor() #获取游标
    try:
        cursor.execute(sql)  #执行SQL
        result = cursor.fetchall() #取所有数据
        for r in result:
            if r[0] == userid and r[1] == pwd:
                return True
        # else:
        #     return False
    except Exception as e:
        print("查询异常")
        print(e)

def print_menu():  #打印菜单
    menu = '''
    --------------- 账户管理系统 ---------------
        1 - 查询账户信息
        2 - 新建账户
        3 - 修改账户
        4 - 删除账户
        5 - 退出
    '''
    print(menu) #打印菜单
    return

#查询账户, 如果用户输入账户, 则以账号为条件进行查询
#如果用户不输入,则查询所有账户
def query_acct(): 
    acct_no = input("请输入要查询的账号:")
    if acct_no and acct_no != "": #用户输入了账户
        sql = '''select * from acct
                 where acct_no = '%s'
        ''' % acct_no
    else:  #用户未输入账户, 查询所有      
        sql = "select * from acct"

    global db_conn
    cursor = db_conn.cursor() #获取游标
    try:
        cursor.execute(sql)  #执行SQL
        result = cursor.fetchall() #取所有数据
        for r in result: #遍历,打印
            acct_no = r[0]   #账号
            acct_name = r[1] #户名
            if r[6]:
                balance = float(r[6])   #余额
            print("账号:%s,户名:%s,余额:%.2f" % \
                (acct_no, acct_name, balance))
    except Exception as e:
        print("查询异常")
        print(e)
    return

def new_acct(): # 新增账户
    try:
        # 准备数据
        acct_no = input("请输入账号:")
        acct_name = input("请输入户名:")
        acct_type = input("请选择账户类型 1-借记卡 2-理财卡:")
        balance = float(input("请输入开户金额:"))
        assert acct_type in ["1","2"]#判断acct_type是否合法
        assert balance >= 10.00
        
        # 拼装SQL语句, 执行插入
        sql = '''insert into acct(acct_no, acct_name,
                                  acct_type, balance)
                values('%s', '%s', %s, %.2f) 
        ''' % (acct_no, acct_name, acct_type, balance)
        # 获取游标,执行
        global db_conn
        cursor = db_conn.cursor()
        cursor.execute(sql)  #执行
        db_conn.commit()     #提交
        print("插入成功")        
    except Exception as e:
        db_conn.rollback()   #回滚事务
        print("插入操作失败")
        print(e)
    return

# create table user_pwd(user varchar(32), pwd varchar(32)) 
# default charset=utf8;
# insert into user_pwd values
# ('libai', 'libai'),
# ('gpf', '123456');

    
def delete_acct():
    acct_no = input("请输入要查询的账号:")
    if acct_no and acct_no != "": #用户输入了账户
        sql = "delete * from acct
                 where acct_no = '%s'"
                 %acct_no
    else:  #用户未输入账户, 删除所有      
        sql = "delete * from acct"

    global db_conn
    cursor = db_conn.cursor() #获取游标
    try:
        cursor.execute(sql)
        db_conn.commit()
        print('delete succeeded')
    except Exception as e:
        print('Failed:', e)
        db_conn.rollback()
    return


#main()
def main():
    # 连接数据库
    if conn_database() < 0:
        return
    # 循环打印菜单, 根据选择的菜单
    # 调用不同函数进行处理
    while True:
        if login_acct():
            print_menu()  #打印菜单
            oper = input("请选择操作:")
            if not oper:  #未输入值
                continue
            if oper == "1":  #查询
                query_acct()
            elif oper == "2": #新建
                new_acct()
            elif oper == "3": #修改
                pass 
            elif oper == "4": #删除
                delete_acct()
            elif oper == "5": #退出
                return
            else:
                print("请输入正确的值")
                continue
        else:
            print('用户名或密码有误，请重试')

    # 关闭数据库
    close_database()

#主函数
if __name__ == "__main__":
    main()

