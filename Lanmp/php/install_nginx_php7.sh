#!/bin/bash

cd ./download
rm -rf ${php_dir}

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
--with-iconv=/usr/local/lib \
--with-gd \
--with-xmlrpc \
--enable-mbstring \
--without-sqlite \
--with-curl \
--enable-ftp \
--with-mcrypt  \
--with-freetype-dir=/usr/local/freetype.2.1.10 \
--with-jpeg-dir=/usr/local/jpeg.9 \
--with-png-dir=/usr/local/libpng.1.6.19 \
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

cp ./php.ini-production ${conf_install_dir}/server/php/etc/php.ini


#adjust php.ini
sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "'${conf_install_dir}'/server/php/lib/php/extensions/no-debug-non-zts-20121212/"#'  ${conf_install_dir}/server/php/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 64M/g' ${conf_install_dir}/server/php/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' ${conf_install_dir}/server/php/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = PRC/g' ${conf_install_dir}/server/php/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' ${conf_install_dir}/server/php/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' ${conf_install_dir}/server/php/etc/php.ini
#adjust php-fpm
cp ${conf_install_dir}/server/php/etc/php-fpm.conf.default ${conf_install_dir}/server/php/etc/php-fpm.conf
sed -i 's,;pid = run/php-fpm.pid,pid = run/php-fpm.pid,g'   ${conf_install_dir}/server/php/etc/php-fpm.conf
sed -i 's,;error_log = log/php-fpm.log,error_log = '${conf_install_dir}'/log/php/php-fpm.log,g'   ${conf_install_dir}/server/php/etc/php-fpm.conf
#adjust www.conf
cp ${conf_install_dir}/server/php/etc/php-fpm.d/www.conf.default ${conf_install_dir}/server/php/etc/php-fpm.d/www.conf
sed -i 's,^pm.min_spare_servers = 1,pm.min_spare_servers = 5,g'   ${conf_install_dir}/server/php/etc/php-fpm.d/www.conf
sed -i 's,^pm.max_spare_servers = 3,pm.max_spare_servers = 35,g'   ${conf_install_dir}/server/php/etc/php-fpm.d/www.conf
sed -i 's,^pm.max_children = 5,pm.max_children = 100,g'   ${conf_install_dir}/server/php/etc/php-fpm.d/www.conf
sed -i 's,^pm.start_servers = 2,pm.start_servers = 20,g'   ${conf_install_dir}/server/php/etc/php-fpm.d/www.conf
sed -i 's,;slowlog = log/$pool.log.slow,slowlog = '${conf_install_dir}'/log/php/\$pool.log.slow,g'   ${conf_install_dir}/server/php/etc/php-fpm.d/www.conf
sed -i "s,user = nobody,user=${conf_web_user},g"   ${conf_install_dir}/server/php/etc/php-fpm.d/www.conf
sed -i "s,group = nobody,group=${conf_web_group},g"   ${conf_install_dir}/server/php/etc/php-fpm.d/www.conf

#self start
install -v -m755 ./sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm
/etc/init.d/php-fpm start
sleep 1

cd ../../

