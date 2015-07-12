#/bin/bash


#--要求用root用户执行-----------------------------------------------------------
if [ `whoami` != 'root' ];then
  echo "+----------------------------+"
  echo "|  plase use root user       |"
  echo "+----------------------------+"
  exit 0
fi


#--获取系统和硬件信息-----------------------------------------------------------
if [ `uname -m` == "x86_64" ];then
  machine=x86_64
else
  machine=i686
fi

CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)


#--conf-------------------------------------------------------------------------
  #--bases
  export conf_install_dir=/xhdata    #your install path
  export conf_web_group=tom          #your install path
  export conf_web_user=tom           #your install path

  #--web server
  export conf_webServer=nginx        #web server type nginx/httpd
  export conf_webServer_ver=1.4.4    #this web server version
  export conf_wget_webServer=http://oss.aliyuncs.com/aliyunecs/onekey/nginx/nginx-1.4.4.tar.gz

  export conf_php_ver=5.5.7          #php version
  export conf_wget_php=http://oss.aliyuncs.com/aliyunecs/onekey/php/php-5.5.7.tar.gz

  export conf_mysql_ver=5.6.15       #mysql version : 32/64
  export conf_wget_mysql=http://oss.aliyuncs.com/aliyunecs/onekey/mysql/mysql-5.6.15-linux-glibc2.5-i686.tar.gz

  #--other
  export vsftpd_version=2.3.2
  export sphinx_version=0.9.9
  export install_ftp_version=0.0.0
  export conf_phpmyadmin=0           #yet install phpmyadmin(1-install; 0-no)
  export export phpmyadmin_version=4.1.8
  export conf_install_log=${conf_install_dir}/website-info.log

  if [ ${conf_webServer} != 'nginx' ];then
    export   conf_wget_apr=http://oss.aliyuncs.com/aliyunecs/onekey/apache/apr-1.5.0.tar.gz
    export   conf_wget_aprUtil=http://oss.aliyuncs.com/aliyunecs/onekey/apache/apr-util-1.5.3.tar.gz
  fi

  export conf_remake_openssl=0  #remove openssl and make again

  export machine
  export CPU_NUM
  export webServer_dir=${conf_webServer}-${conf_webServer_ver}
  export php_dir=php-${conf_php_ver}
  export mysql_dir=mysql-${conf_mysql_ver}
  export vsftpd_dir=vsftpd-${vsftpd_version}
  export sphinx_dir=sphinx-${sphinx_version}

  export ifredhat=$(cat /proc/version | grep redhat)
  export ifcentos=$(cat /proc/version | grep centos)
  export ifubuntu=$(cat /proc/version | grep ubuntu)
  export ifdebian=$(cat /proc/version | grep -i debian)


#--Version Info-----------------------------------------------------------------
echo "+----------------------------------------------------+"
echo "| Version Info:"
echo "| web    : ${conf_webServer}"
echo "| ${conf_webServer} : ${conf_webServer_ver}"
echo "| php    : $conf_php_ver"
echo "| mysql  : $conf_mysql_ver"
echo "+----------------------------------------------------+"

read -p "Enter the y or Y to continue:" isY
if [ "${isY}" != "y" ] && [ "${isY}" != "Y" ];then
   exit 1
fi


#--Clean up the environment-----------------------------------------------------
echo ""
echo "will be installed, wait ..."
echo ""
./uninstall.sh in &> /dev/null


#--install dependencies---------------------------------------------------------
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


#--install software-------------------------------------------------------------
rm -f tmp.log
echo tmp.log

./env/install_set_sysctl.sh
./env/install_set_ulimit.sh

if [ -e /dev/xvdb ];then
	./env/install_disk.sh
fi

echo "+--------------------------------------------+" >> tmp.log
./env/install_dir.sh
echo "| make dir ok " >> tmp.log

./env/install_env.sh
echo "| env ok " >> tmp.log

./mysql/install_mysql.sh
echo "| mysql ${conf_mysql_ver} ok " >> tmp.log

./${conf_webServer}/install_${conf_webServer}.sh
echo "| ${webServer_dir} ok " >> tmp.log

./php/install_${conf_webServer}_php.sh
echo "| php ${conf_php_ver} ok " >> tmp.log

./php/install_php_extension.sh
echo "| php extension ok " >> tmp.log

./ftp/install_${vsftpd_dir}.sh
install_ftp_version=$(vsftpd -v 0> vsftpd_version && cat vsftpd_version |awk -F: '{print $2}'|awk '{print $2}' && rm -f vsftpd_version)
echo "| vsftpd-$install_ftp_version  ok " >> tmp.log

./res/install_soft.sh


#--Start command is written to the rc.local-------------------------------------
if ! cat /etc/rc.local | grep "/etc/init.d/mysqld" > /dev/null;then
    echo "/etc/init.d/mysqld start" >> /etc/rc.local
fi
if echo ${conf_webServer}|grep "nginx" > /dev/null;then
  if ! cat /etc/rc.local | grep "/etc/init.d/nginx" > /dev/null;then
     echo "/etc/init.d/nginx start" >> /etc/rc.local
	 echo "/etc/init.d/php-fpm start" >> /etc/rc.local
  fi
else
  if ! cat /etc/rc.local | grep "/etc/init.d/httpd" > /dev/null;then
     echo "/etc/init.d/httpd start" >> /etc/rc.local
  fi
fi
if ! cat /etc/rc.local | grep "/etc/init.d/vsftpd" > /dev/null;then
    echo "/etc/init.d/vsftpd start" >> /etc/rc.local
fi


#--centos yum configuration-----------------------------------------------------
if [ "$ifcentos" != "" ] && [ "$machine" == "x86_64" ];then
sed -i 's/^#exclude/exclude/' /etc/yum.conf
fi
if [ "$ifubuntu" != "" ] || [ "$ifdebian" != "" ];then
	mkdir -p /var/lock
	sed -i 's#exit 0#touch /var/lock/local#' /etc/rc.local
else
	mkdir -p /var/lock/subsys/
fi


#--mysql password initialization------------------------------------------------
echo "| rc init ok " >> tmp.log
${conf_install_dir}/server/php/bin/php -f ./res/init_mysql.php
echo "| mysql init ok " >> tmp.log
echo "+--------------------------------------------+" >> tmp.log


#--Environment variable settings------------------------------------------------
\cp /etc/profile /etc/profile.bak
if echo ${conf_webServer}|grep "nginx" > /dev/null;then
  echo 'export PATH=$PATH:${conf_install_dir}/server/mysql/bin:${conf_install_dir}/server/nginx/sbin:${conf_install_dir}/server/php/sbin:${conf_install_dir}/server/php/bin' >> /etc/profile
  export PATH=$PATH:${conf_install_dir}/server/mysql/bin:${conf_install_dir}/server/nginx/sbin:${conf_install_dir}/server/php/sbin:${conf_install_dir}/server/php/bin
else
  echo 'export PATH=$PATH:${conf_install_dir}/server/mysql/bin:${conf_install_dir}/server/httpd/bin:${conf_install_dir}/server/php/sbin:${conf_install_dir}/server/php/bin' >> /etc/profile
  export PATH=$PATH:${conf_install_dir}/server/mysql/bin:${conf_install_dir}/server/httpd/bin:${conf_install_dir}/server/php/sbin:${conf_install_dir}/server/php/bin
fi


#--start servers----------------------------------------------------------------
if echo ${conf_webServer}|grep "nginx" > /dev/null;then
/etc/init.d/php-fpm restart > /dev/null
/etc/init.d/nginx restart > /dev/null
else
/etc/init.d/httpd restart > /dev/null
/etc/init.d/httpd start &> /dev/null
fi
/etc/init.d/vsftpd restart


#--show log---------------------------------------------------------------------
\cp tmp.log $conf_install_log
cat $conf_install_log



