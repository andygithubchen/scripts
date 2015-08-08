#!/bin/bash

cd ./download
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
--with-debug

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

cp -fR ./nginx/config-nginx/* ${conf_install_dir}/server/nginx/conf/

sed -i 's/\${conf_install_dir}/\'${conf_install_dir}'/g' `grep conf_install_dir -rl ${conf_install_dir}/server/nginx/conf/`
sed -i "s/\${conf_web_user}/${conf_web_user}/g"  ${conf_install_dir}/server/nginx/conf/nginx.conf
sed -i "s/\${conf_web_group}/${conf_web_group}/g"  ${conf_install_dir}/server/nginx/conf/nginx.conf
sed -i 's/worker_processes  2/worker_processes  '"$CPU_NUM"'/' ${conf_install_dir}/server/nginx/conf/nginx.conf

chmod 755 ${conf_install_dir}/server/nginx/sbin/nginx
mv ${conf_install_dir}/server/nginx/conf/nginx /etc/init.d/
chmod +x /etc/init.d/nginx

/etc/init.d/nginx start

