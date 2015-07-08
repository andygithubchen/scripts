#!/bin/bash


rm -rf ${webServer_dir} apr apr-util
if [ ! -f ${webServer_dir}.tar.gz ];then
  wget -O ${webServer_dir}.tar.gz ${conf_wget_webServer}
fi
tar zxvf ${webServer_dir}.tar.gz

if [ ! -f apr.tar.gz ];then
  wget -O apr.tar.gz ${conf_wget_apr}
fi
tar -zxvf apr.tar.gz
cp -rf apr ${webServer_dir}/srclib/apr

if [ ! -f apr-util.tar.gz ];then
  wget -O apr-util.tar.gz ${conf_wget_aprUtil}
fi
tar -zxvf apr-util.tar.gz
cp -rf apr-util ${webServer_dir}/srclib/apr-util

cd ${webServer_dir}
./configure --prefix=${conf_install_dir}/server/httpd \
--with-mpm=prefork \
--enable-so \
--enable-rewrite \
--enable-mods-shared=all \
--enable-nonportable-atomics=yes \
--disable-dav \
--enable-deflate \
--enable-cache \
--enable-disk-cache \
--enable-mem-cache \
--enable-file-cache \
--enable-ssl \
--with-included-apr \
--enable-modules=all  \
--enable-mods-shared=all

if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cp support/apachectl /etc/init.d/httpd
chmod u+x /etc/init.d/httpd
cd ..

cp ${conf_install_dir}/server/httpd/conf/httpd.conf ${conf_install_dir}/server/httpd/conf/httpd.conf.bak

sed -i "s;#LoadModule rewrite_module modules/mod_rewrite.so;LoadModule rewrite_module modules/mod_rewrite.so\nLoadModule php5_module modules/libphp5.so;" ${conf_install_dir}/server/httpd/conf/httpd.conf
sed -i "s#User daemon#User ${conf_web_user}#" ${conf_install_dir}/server/httpd/conf/httpd.conf
sed -i "s#Group daemon#Group ${conf_web_group}#" ${conf_install_dir}/server/httpd/conf/httpd.conf
sed -i "s;#ServerName www.example.com:80;ServerName www.example.com:80;" ${conf_install_dir}/server/httpd/conf/httpd.conf
sed -i "s#${conf_install_dir}/server/httpd/htdocs#${conf_install_dir}/wwwroot#" ${conf_install_dir}/server/httpd/conf/httpd.conf
sed -i "s#<Directory />#<Directory \"${conf_install_dir}/wwwroot\">#" ${conf_install_dir}/server/httpd/conf/httpd.conf
sed -i "s#AllowOverride None#AllowOverride all#" ${conf_install_dir}/server/httpd/conf/httpd.conf
sed -i "s#DirectoryIndex index.html#DirectoryIndex index.html index.htm index.php#" ${conf_install_dir}/server/httpd/conf/httpd.conf
sed -i "s;#Include conf/extra/httpd-mpm.conf;Include conf/extra/httpd-mpm.conf;" ${conf_install_dir}/server/httpd/conf/httpd.conf
sed -i "s;#Include conf/extra/httpd-vhosts.conf;Include conf/extra/httpd-vhosts.conf;" ${conf_install_dir}/server/httpd/conf/httpd.conf

echo "HostnameLookups off" >> ${conf_install_dir}/server/httpd/conf/httpd.conf
echo "AddType application/x-httpd-php .php" >> ${conf_install_dir}/server/httpd/conf/httpd.conf

echo "Include ${conf_install_dir}/server/httpd/conf/vhosts/*.conf" > ${conf_install_dir}/server/httpd/conf/extra/httpd-vhosts.conf


mkdir -p ${conf_install_dir}/server/httpd/conf/vhosts/
cat > ${conf_install_dir}/server/httpd/conf/vhosts/sample.conf << END
<DirectoryMatch "${conf_install_dir}/wwwroot/sample/(attachment|html|data)">
<Files ~ ".php">
Order allow,deny
Deny from all
</Files>
</DirectoryMatch>

<VirtualHost *:80>
	DocumentRoot ${conf_install_dir}/wwwroot/sample
	ServerName localhost
	ServerAlias localhost
	<Directory "${conf_install_dir}/wwwroot/sample">
	    Options Indexes FollowSymLinks
	    AllowOverride all
	    Order allow,deny
	    Allow from all
	</Directory>
	<IfModule mod_rewrite.c>
		RewriteEngine On
		RewriteRule ^(.*)-htm-(.*)$ $1.php?$2
		RewriteRule ^(.*)/simple/([a-z0-9\_]+\.html)$ $1/simple/index.php?$2
	</IfModule>
	ErrorLog "${conf_install_dir}/log/httpd/sample-error.log"
	CustomLog "${conf_install_dir}/log/httpd/sample.log" common
</VirtualHost>
END

#adjust httpd-mpm.conf
sed -i 's/StartServers             5/StartServers            10/g' ${conf_install_dir}/server/httpd/conf/extra/httpd-mpm.conf
sed -i 's/MinSpareServers          5/MinSpareServers         10/g' ${conf_install_dir}/server/httpd/conf/extra/httpd-mpm.conf
sed -i 's/MaxSpareServers         10/MaxSpareServers         30/g' ${conf_install_dir}/server/httpd/conf/extra/httpd-mpm.conf
sed -i 's/MaxRequestWorkers      150/MaxRequestWorkers      255/g' ${conf_install_dir}/server/httpd/conf/extra/httpd-mpm.conf

/etc/init.d/httpd start



