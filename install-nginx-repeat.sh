#!/bin/bash

export conf_webServer=nginx        #web server type nginx/httpd
export conf_webServer_ver=1.15.6   #this web server version
export conf_wget_webServer=http://nginx.org/download/nginx-1.15.6.tar.gz
export conf_install_dir=/andydata    #your install path
export CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
export conf_web_group=www          #web group
export conf_web_user=www           #web user
export webServer_dir=${conf_webServer}-${conf_webServer_ver}


# install libbrotli
cd /usr/local/src/
git clone https://github.com/bagder/libbrotli
cd libbrotli
./autogen.sh
./configure
make && make install

# install ngi_brotli
cd /usr/local/src/
git clone https://github.com/google/ngx_brotli
cd ./ngx_brotli
git submodule update --init

cd  ~/tmp
wget -c ${conf_wget_webServer}
rm -rf ${webServer_dir}

tar zxvf ${webServer_dir}.tar.gz
cd ${webServer_dir}

./configure --prefix=${conf_install_dir}/server/nginx \
--user=${conf_web_user} \
--group=${conf_web_group} \
--with-http_ssl_module \
--without-http-cache \
--with-http_gzip_static_module \
--with-http_stub_status_module \
--with-debug \
--add-module=/usr/local/src/ngx_brotli

if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install

chmod 775 ${conf_install_dir}/server/nginx/logs
chown -R ${conf_web_group}:${conf_web_user} ${conf_install_dir}/server/nginx/logs
chmod -R 775 ${conf_install_dir}/wwwroot
chown -R ${conf_web_group}:${conf_web_user} ${conf_install_dir}/wwwroot
cd ../../

cp -fR ~/ng_conf/* ${conf_install_dir}/server/nginx/conf/

sed -i 's/\${conf_install_dir}/\'${conf_install_dir}'/g' `grep conf_install_dir -rl ${conf_install_dir}/server/nginx/conf/`
sed -i "s/\${conf_web_user}/${conf_web_user}/g"  ${conf_install_dir}/server/nginx/conf/nginx.conf
sed -i "s/\${conf_web_group}/${conf_web_group}/g"  ${conf_install_dir}/server/nginx/conf/nginx.conf
sed -i 's/worker_processes  2/worker_processes  '"$CPU_NUM"'/' ${conf_install_dir}/server/nginx/conf/nginx.conf

chmod 755 ${conf_install_dir}/server/nginx/sbin/nginx
mv ${conf_install_dir}/server/nginx/conf/nginx /etc/init.d/
chmod +x /etc/init.d/nginx

/etc/init.d/nginx start



# nginx conf
#
# brotli on;
# brotli_types *;
#
#
