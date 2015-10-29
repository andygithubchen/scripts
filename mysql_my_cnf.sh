#!/bin/bash

#1：设置mysql 的配置文件
#   /etc/my.cnf
#   找到 bind-address  =127.0.0.1  将其注释掉；//作用是使得不再只允许本地访问；
#   重启mysql：
#   /etc/init.d/mysql restart;
#
#
#2：进入mysql 数据库
#   mysql -u  root -p
#   mysql>GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
#   其中 第一个*表示数据库名；第二个*表示该数据库的表名；如果像上面那样 *.*的话表示所有到数据库下到所有表都允许访问；
#   ‘%’：表示允许访问到mysql的ip地址；当然你也可以配置为具体到ip名称；%表示所有ip均可以访问；
#   后面到‘xxxx’为root 用户的password；
#
#
#3：关闭防火墙！
