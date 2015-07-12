#!/bin/bash

userdel ${conf_web_user}
groupadd ${conf_web_group}
useradd -g ${conf_web_user} -M -d ${conf_install_dir}/wwwroot -s /sbin/nologin ${conf_web_user} &> /dev/null

mkdir -p ${conf_install_dir}
mkdir -p ${conf_install_dir}/server
mkdir -p ${conf_install_dir}/wwwroot
mkdir -p ${conf_install_dir}/log
mkdir -p ${conf_install_dir}/log/php
mkdir -p ${conf_install_dir}/log/mysql
mkdir -p ${conf_install_dir}/log/nginx
mkdir -p ${conf_install_dir}/log/nginx/access
chown -R ${conf_web_group}:${conf_web_user} ${conf_install_dir}/log

mkdir -p ${conf_install_dir}/server/${mysql_dir}
ln -s ${conf_install_dir}/server/${mysql_dir} ${conf_install_dir}/server/mysql

mkdir -p ${conf_install_dir}/server/${php_dir}
ln -s ${conf_install_dir}/server/${php_dir} ${conf_install_dir}/server/php


mkdir -p ${conf_install_dir}/server/${webServer_dir}
if echo ${conf_webServer} |grep "nginx" > /dev/null;then
  mkdir -p ${conf_install_dir}/log/nginx
  mkdir -p ${conf_install_dir}/log/nginx/access
  ln -s ${conf_install_dir}/server/${webServer_dir} ${conf_install_dir}/server/nginx
else
  mkdir -p ${conf_install_dir}/log/httpd
  mkdir -p ${conf_install_dir}/log/httpd/access
  ln -s ${conf_install_dir}/server/${webServer_dir} ${conf_install_dir}/server/httpd
fi
