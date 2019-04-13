#!/bin/bash

if [ ! -f ./zabbix-3.4.3.tar.gz ]; then
  rm -fr ./zabbix-3.4.3
  wget https://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/3.4.3/zabbix-3.4.3.tar.gz/download
  mv ./download ./zabbix-3.4.3.tar.gz
  tar -zxvf ./zabbix-3.4.3.tar.gz
fi


cd ./zabbix-3.4.3

mysql -uroot -p123456 << EOF
  create database zabbix default charset utf8;
  grant all on zabbix.* to zabbix@'localhost' identified by '123456';
  grant all on zabbix.* to zabbix@'127.0.0.1' identified by '123456';
EOF

mysql -uzabbix -p123456 zabbix < ./database/mysql/schema.sql
mysql -uzabbix -p123456 zabbix < ./database/mysql/images.sql
mysql -uzabbix -p123456 zabbix < ./database/mysql/data.sql


groupadd zabbix
useradd -g zabbix -m zabbix

apt-get install -y libsnmp-dev snmp

./configure \
--prefix=/usr/local/zabbix \
--enable-server \
--with-mysql=/andydata/server/mysql/bin/mysql_config \
--with-net-snmp \
--with-libcurl \
--enable-ipv6 \
--with-libxml2 \
--enable-agent

make && make install


sed -i "s/sbin/zabbix\/sbin/" ./misc/init.d/debian/zabbix-server
sed -i "s/sbin/zabbix\/sbin/" ./misc/init.d/debian/zabbix-agent

cp ./misc/init.d/debian/zabbix-* /etc/init.d/


# 配置zabbix server端
# vim /usr/local/zabbix/etc/zabbix_server.conf

# 配置zabbix agent端
# vim /usr/local/zabbix/etc/zabbix_agentd.conf

update-rc.d zabbix-server defaults
update-rc.d zabbix-agent defaults

service zabbix_server start
service zabbix_agentd start




# 部署zabbix监控站点======================================

#cp -r ./frontends/php /andydata/wwwroot/zabbix
#chown www:www -R /andydata/wwwroot/zabbix/

#修改php.ini配置来配合zabbix
#按这里修改：https://www.zabbix.com/documentation/3.4/zh/manual/installation/install


#登陆界面输入账号admin,密码zabbix进入

#支持中文 http://www.phperz.com/article/15/0531/131543.html


