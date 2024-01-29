#/bin/bash

export DIR=$(pwd)


#--要求用root用户执行-----------------------------------------------------------+
if [ `whoami` != 'root' ];then
  echo "+----------------------------+"
  echo "|  plase use root user       |"
  echo "+----------------------------+"
  exit 0
fi


#--conf-------------------------------------------------------------------------+
  export isDependencies=1            #yet need dependencies install
  export isEnv=1                     #yet install env's
  export conf_remake_openssl=0  #remove openssl and make again

  #--bases
  export conf_install_dir=/andydata    #your install path
  export conf_web_group=www          #web group
  export conf_web_user=www           #web user

  #--web servers
  export conf_webServer=nginx        #web server type nginx/httpd
  export conf_webServer_ver=1.15.12   #this web server version
  export conf_wget_webServer=https://nginx.org/download/nginx-1.15.12.tar.gz

  export conf_php_ver=7.2.8         #php version
  export conf_php7=7         #php version
  export conf_wget_php=https://www.php.net/distributions/php-7.2.8.tar.gz

  export conf_mysql_ver=8.0.21
  export conf_wget_mysql=https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-boost-8.0.21.tar.gz

  #export conf_mysql_ver=5.7.10       #mysql version : 32/64
  #export conf_wget_mysql=https://cdn.mysql.com//archives/mysql-5.7/mysql-5.7.10-linux-glibc2.5-x86_64.tar.gz

  #export conf_mysql_ver=5.5.35
  #export conf_wget_mysql=http://developers-origin.cloudsoftcorp.com/brooklyn/repository/MySqlNode/5.5.35/mysql-5.5.35-linux2.6-x86_64.tar.gz

  #--other
  export vsftpd_version=2.3.2
  export conf_phpmyadmin=0           #yet install phpmyadmin(1-install; 0-no)
  export phpmyadmin_version=4.1.8
  export conf_install_log=${conf_install_dir}/website-info.log

  if [ ${conf_webServer} != 'nginx' ];then
    export conf_wget_apr=http://oss.aliyuncs.com/aliyunecs/onekey/apache/apr-1.5.0.tar.gz
    export conf_wget_aprUtil=http://oss.aliyuncs.com/aliyunecs/onekey/apache/apr-util-1.5.3.tar.gz
  fi


  if [ `uname -m` == "x86_64" ];then
    export machine=x86_64
  else
    export machine=i686
  fi
  export CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
  export webServer_dir=${conf_webServer}-${conf_webServer_ver}
  export php_dir=php-${conf_php_ver}
  export mysql_dir=mysql-${conf_mysql_ver}
  export vsftpd_dir=vsftpd-${vsftpd_version}
  export sphinx_dir=sphinx-${sphinx_version}

  export ifredhat=$(cat /proc/version | grep redhat)
  export ifcentos=$(cat /proc/version | grep centos)
  export ifubuntu=$(cat /proc/version | grep ubuntu)
  export ifdebian=$(cat /proc/version | grep -i debian)

#--Select module----------------------------------------------------------------+
echo "+----------------------------------------------------+"
echo "| newly install or test install :"
echo "+----------------------------------------------------+"
read -p "Enter the n or t to continue:" module
if [ "${module}" == "t" ] ;then
    echo "+----------------------------------------------------+"
    echo "| newly install php or mysql or ${conf_webServer} :"
    echo "+----------------------------------------------------+"
    read -p "Enter the server to continue:" test_server
    if [[ ! "php mysql ${conf_webServer}" =~ ${test_server} ]];then
        exit 1
    fi
elif [ "${module}" != 'n' ];then
    exit 1
fi


#--Version Info-----------------------------------------------------------------+
if [ ${module} == 'n' ];then
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
fi


#--download all tar.gz files----------------------------------------------------+
if [ ${module} == 'n' ];then
  echo ''
  echo "download all tar.gz files"
  echo ''
  cd ./download
  ./download.sh
  cd -
fi


#--install dependencies---------------------------------------------------------+
if [ ${module} == 'n' ] && [ ${isDependencies} == 1 ];then
  ./dependencies/install.sh
	echo ""
	echo "+----------------------------------------------+"
	echo "+ dependencies install done                    +"
	echo "+----------------------------------------------+"
	echo ""
fi


#--Clean up the environment-----------------------------------------------------+
if [ ${module} == 'n' ];then
  echo ""
  echo " uninstall ..."
  echo ""
  ./uninstall.sh in &> /dev/null
fi

echo ""
echo " will be installed, wait ..."
echo ""


#--install software-------------------------------------------------------------+
rm -f tmp.log
echo tmp.log

if [ ${module} == 'n' ];then
  ./env/install_set_sysctl.sh
  ./env/install_set_ulimit.sh
  if [ -e /dev/xvdb ];then
    ./env/install_disk.sh
  fi
fi


echo "+--------------------------------------------+" >> tmp.log
./env/install_dir.sh
echo "| make dir ok " >> tmp.log

if [ ${module} == 'n' ] && [ ${isEnv} == 1 ];then
  ./env/install_env.sh
  echo "| env ok " >> tmp.log
fi


# install Mysql -------------------------------------------#
if [ ${module} == 'n' ] || [ ${test_server} == 'mysql' ];then
  if [ ${conf_mysql_ver} == '8.0.21' ];then
    ./mysql/install_mysql80.sh
  elif [ ${conf_mysql_ver} == '5.5.35' ];then
    ./mysql/install_mysql55.sh
  else
    ./mysql/install_mysql.sh
  fi
  echo "| mysql ${conf_mysql_ver} ok " >> tmp.log
  if [ ${test_server} == 'mysql' ];then
    exit 1
  fi
fi


# install HTTP --------------------------------------------#
if [ ${module} == 'n' ] || [ ${test_server} == ${conf_webServer} ];then
  ./${conf_webServer}/install_${conf_webServer}.sh
  echo "| ${webServer_dir} ok " >> tmp.log
  if [ ${test_server} == ${conf_webServer} ];then
    exit 1
  fi
fi


# install PHP ---------------------------------------------#
if [ ${module} == 'n' ] || [ ${test_server} == 'php' ];then
  ./php/install_${conf_webServer}_php${conf_php7}.sh
  echo "| php ${conf_php_ver} ok " >> tmp.log
  ./php/install_php_extension.sh
  echo "| php extension ok " >> tmp.log
  if [ ${test_server} == 'php' ];then
    exit 1
  fi
fi


# install Ftp ---------------------------------------------#
if [ ${module} == 'n' ];then
  ./ftp/install_${vsftpd_dir}.sh
  install_ftp_version=$(vsftpd -v 0> vsftpd_version && cat vsftpd_version |awk -F: '{print $2}'|awk '{print $2}' && rm -f vsftpd_version)
  echo "| vsftpd-$install_ftp_version  ok " >> tmp.log
fi

if [ ${module} == 'n' ] || [ ${test_server} == ${conf_webServer} ];then
  ./res/install_soft.sh
  if [ ${test_server} == ${conf_webServer} ];then
    exit 1
  fi
fi


#--Start command is written to the rc.local-------------------------------------+
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


#--System configuration---------------------------------------------------------+
if [ ${module} == 'n' ];then
  if [ "$ifcentos" != "" ] && [ "$machine" == "x86_64" ];then
  sed -i 's/^#exclude/exclude/' /etc/yum.conf
  fi
  if [ "$ifubuntu" != "" ] || [ "$ifdebian" != "" ];then
    mkdir -p /var/lock
    sed -i 's#exit 0#touch /var/lock/local#' /etc/rc.local
  else
    mkdir -p /var/lock/subsys/
  fi
fi


#--mysql password initialization------------------------------------------------+
if [ ${module} == 'n' ] || [ ${test_server} == 'php' ];then
  echo "| rc init ok " >> tmp.log
  ${conf_install_dir}/server/php/bin/php -f ./res/init_mysql.php
  echo "| mysql init ok " >> tmp.log
  echo "+--------------------------------------------+" >> tmp.log
fi


#--Environment variable settings------------------------------------------------+
\cp /etc/profile /etc/profile.bak
if echo ${conf_webServer}|grep "nginx" > /dev/null;then
  echo "export PATH=$PATH:${conf_install_dir}/server/mysql/bin:${conf_install_dir}/server/nginx/sbin:${conf_install_dir}/server/php/sbin:${conf_install_dir}/server/php/bin" >> /etc/profile
  export PATH=$PATH:${conf_install_dir}/server/mysql/bin:${conf_install_dir}/server/nginx/sbin:${conf_install_dir}/server/php/sbin:${conf_install_dir}/server/php/bin
else
  echo "export PATH=$PATH:${conf_install_dir}/server/mysql/bin:${conf_install_dir}/server/httpd/bin:${conf_install_dir}/server/php/sbin:${conf_install_dir}/server/php/bin" >> /etc/profile
  export PATH=$PATH:${conf_install_dir}/server/mysql/bin:${conf_install_dir}/server/httpd/bin:${conf_install_dir}/server/php/sbin:${conf_install_dir}/server/php/bin
fi
source /etc/profile

#--start servers----------------------------------------------------------------+
if echo ${conf_webServer}|grep "nginx" > /dev/null;then
  /etc/init.d/php-fpm restart > /dev/null
  /etc/init.d/nginx restart > /dev/null
else
  /etc/init.d/httpd restart > /dev/null
  /etc/init.d/httpd start &> /dev/null
fi
service mysqld start
service nginx start

/etc/init.d/vsftpd restart

#--show log---------------------------------------------------------------------+
\cp tmp.log $conf_install_log
cat $conf_install_log


