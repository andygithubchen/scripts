#/bin/bash

#install dependencies

if [ "$ifcentos" != "" ] || [ "$machine" == "i686" ];then
  rpm -e httpd-2.2.3-31.el5.centos gnome-user-share &> /dev/null
fi

\cp /etc/rc.local /etc/rc.local.bak
if [ "$ifredhat" != "" ];then
  rpm -e --allmatches mysql MySQL-python perl-DBD-MySQL dovecot exim qt-MySQL perl-DBD-MySQL dovecot qt-MySQL mysql-server mysql-connector-odbc php-mysql mysql-bench libdbi-dbd-mysql mysql-devel-5.0.77-3.el5 httpd php mod_auth_mysql mailman squirrelmail php-pdo php-common php-mbstring php-cli &> /dev/null
fi

if [ "$ifredhat" != "" ];then
  \mv /etc/yum.repos.d/rhel-debuginfo.repo /etc/yum.repos.d/rhel-debuginfo.repo.bak &> /dev/null
  \cp ./res/rhel-debuginfo.repo /etc/yum.repos.d/
  yum makecache
  yum -y remove mysql MySQL-python perl-DBD-MySQL dovecot exim qt-MySQL perl-DBD-MySQL dovecot qt-MySQL mysql-server mysql-connector-odbc php-mysql mysql-bench libdbi-dbd-mysql mysql-devel-5.0.77-3.el5 httpd php mod_auth_mysql mailman squirrelmail php-pdo php-common php-mbstring php-cli &> /dev/null
  yum -y install gcc gcc-c++ gcc-g77 make libtool autoconf patch unzip automake fiex* libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl libmcrypt libmcrypt-devel libpng libpng-devel libjpeg-devel openssl openssl-devel curl curl-devel libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl autoconf automake libaio*
  iptables -F
elif [ "$ifcentos" != "" ];then
  sed -i 's/^exclude/#exclude/' /etc/yum.conf
  yum makecache
  yum -y remove mysql MySQL-python perl-DBD-MySQL dovecot exim qt-MySQL perl-DBD-MySQL dovecot qt-MySQL mysql-server mysql-connector-odbc php-mysql mysql-bench libdbi-dbd-mysql mysql-devel-5.0.77-3.el5 httpd php mod_auth_mysql mailman squirrelmail php-pdo php-common php-mbstring php-cli &> /dev/null
  yum -y install gcc gcc-c++ gcc-g77 make libtool autoconf patch unzip automake libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl libmcrypt libmcrypt-devel libpng libpng-devel libjpeg-devel openssl openssl-devel curl curl-devel libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl autoconf automake libaio*
  iptables -F
elif [ "$ifubuntu" != "" ];then
  apt-get -y update
  \mv /etc/apache2 /etc/apache2.bak &> /dev/null
  \mv /etc/nginx /etc/nginx.bak &> /dev/null
  \mv /etc/php5 /etc/php5.bak &> /dev/null
  \mv /etc/mysql /etc/mysql.bak &> /dev/null
  apt-get -y autoremove apache2 nginx php5 mysql-server &> /dev/null
  apt-get -y install unzip build-essential libncurses5-dev libfreetype6-dev libxml2-dev libssl-dev libcurl4-openssl-dev libjpeg62-dev libpng12-dev libfreetype6-dev libsasl2-dev libpcre3-dev autoconf libperl-dev libtool libaio*
  iptables -F
elif [ "$ifdebian" != "" ];then
  apt-get -y update
  \mv /etc/apache2 /etc/apache2.bak &> /dev/null
  \mv /etc/nginx /etc/nginx.bak &> /dev/null
  \mv /etc/php5 /etc/php5.bak &> /dev/null
  \mv /etc/mysql /etc/mysql.bak &> /dev/null
  apt-get -y autoremove apache2 nginx php5 mysql-server &> /dev/null
  apt-get -y install unzip psmisc build-essential libncurses5-dev libfreetype6-dev libxml2-dev libssl-dev libcurl4-openssl-dev libjpeg62-dev libpng12-dev libfreetype6-dev libsasl2-dev libpcre3-dev autoconf libperl-dev libtool libaio*
  iptables -F
fi


