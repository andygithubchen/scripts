#!/bin/bash




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

  #export conf_php_ver=5.5.7          #php version
  export conf_php_ver=5.4.43          #php version
  #export conf_wget_php=http://oss.aliyuncs.com/aliyunecs/onekey/php/php-5.5.7.tar.gz
  export conf_wget_php=http://php.net/distributions/php-5.4.43.tar.gz

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

  export machine
  export CPU_NUM
  export webServer_dir=${conf_webServer}-${conf_webServer_ver}
  export php_dir=php-${conf_php_ver}
  export mysql_dir=mysql-${conf_mysql_ver}
  export vsftpd_dir=vsftpd-${vsftpd_version}
  export sphinx_dir=sphinx-${sphinx_version}






rm -rf ${php_dir}
if [ ! -f ${php_dir}.tar.gz ];then
  wget ${conf_wget_php}
fi

tar zxvf ${php_dir}.tar.gz
cd ${php_dir}

./configure --prefix=${conf_install_dir}/server/php \
--enable-opcache \
--with-config-file-path=${conf_install_dir}/server/php/etc \
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--enable-fpm \
--enable-fastcgi \
--enable-static \
--enable-inline-optimization \
--enable-sockets \
--enable-wddx \
--enable-zip \
--enable-calendar \
--enable-bcmath \
--enable-soap \
--with-zlib \
--with-iconv \
--with-gd \
--with-xmlrpc \
--enable-mbstring \
--without-sqlite \
--with-curl \
--enable-ftp \
--with-mcrypt  \
--with-freetype-dir=/usr/local/freetype.2.1.10 \
--with-jpeg-dir=/usr/local/jpeg.6 \
--with-png-dir=/usr/local/libpng.1.2.50 \
--disable-ipv6 \
--disable-debug \
--with-openssl \
--disable-maintainer-zts \
--disable-safe-mode \
--disable-fileinfo

if [ $CPU_NUM -gt 1 ];then
    make ZEND_EXTRA_LIBS='-liconv' -j$CPU_NUM
else
    make ZEND_EXTRA_LIBS='-liconv'
fi
make install
cd ..
cp ./${php-dir}/php.ini-production ${conf_install_dir}/server/php/etc/php.ini
#adjust php.ini
sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "'${conf_install_dir}'/server/php/lib/php/extensions/no-debug-non-zts-20121212/"#'  ${conf_install_dir}/server/php/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 64M/g' ${conf_install_dir}/server/php/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' ${conf_install_dir}/server/php/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = PRC/g' ${conf_install_dir}/server/php/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' ${conf_install_dir}/server/php/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' ${conf_install_dir}/server/php/etc/php.ini
#adjust php-fpm
cp ${conf_install_dir}/server/php/etc/php-fpm.conf.default ${conf_install_dir}/server/php/etc/php-fpm.conf
sed -i "s,user = nobody,user=${conf_web_user},g"   ${conf_install_dir}/server/php/etc/php-fpm.conf
sed -i "s,group = nobody,group=${conf_web_group},g"   ${conf_install_dir}/server/php/etc/php-fpm.conf
sed -i 's,^pm.min_spare_servers = 1,pm.min_spare_servers = 5,g'   ${conf_install_dir}/server/php/etc/php-fpm.conf
sed -i 's,^pm.max_spare_servers = 3,pm.max_spare_servers = 35,g'   ${conf_install_dir}/server/php/etc/php-fpm.conf
sed -i 's,^pm.max_children = 5,pm.max_children = 100,g'   ${conf_install_dir}/server/php/etc/php-fpm.conf
sed -i 's,^pm.start_servers = 2,pm.start_servers = 20,g'   ${conf_install_dir}/server/php/etc/php-fpm.conf
sed -i 's,;pid = run/php-fpm.pid,pid = run/php-fpm.pid,g'   ${conf_install_dir}/server/php/etc/php-fpm.conf
sed -i 's,;error_log = log/php-fpm.log,error_log = '${conf_install_dir}'/log/php/php-fpm.log,g'   ${conf_install_dir}/server/php/etc/php-fpm.conf
sed -i 's,;slowlog = log/$pool.log.slow,slowlog = '${conf_install_dir}'/log/php/\$pool.log.slow,g'   ${conf_install_dir}/server/php/etc/php-fpm.conf
#self start
install -v -m755 ./${php-dir}/sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm
/etc/init.d/php-fpm start
sleep 5


