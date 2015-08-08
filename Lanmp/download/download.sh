#!/bin/bash

array=(
  http://oss.aliyuncs.com/aliyunecs/onekey/php_extend/ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz
  http://oss.aliyuncs.com/aliyunecs/onekey/php_extend/ZendGuardLoader-php-5.3-linux-glibc23-i386.tar.gz
  http://oss.aliyuncs.com/aliyunecs/onekey/php_extend/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
  http://oss.aliyuncs.com/aliyunecs/onekey/php_extend/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-i386.tar.gz
  http://oss.aliyuncs.com/aliyunecs/onekey/libiconv-1.13.1.tar.gz
  http://oss.aliyuncs.com/aliyunecs/onekey/zlib-1.2.3.tar.gz
  http://oss.aliyuncs.com/aliyunecs/onekey/freetype-2.1.10.tar.gz
  http://oss.aliyuncs.com/aliyunecs/onekey/libpng-1.2.50.tar.gz
  http://oss.aliyuncs.com/aliyunecs/onekey/libevent-1.4.14b.tar.gz
  http://oss.aliyuncs.com/aliyunecs/onekey/libmcrypt-2.5.8.tar.gz
  http://oss.aliyuncs.com/aliyunecs/onekey/pcre-8.12.tar.gz
  http://oss.aliyuncs.com/aliyunecs/onekey/jpegsrc.v6b.tar.gz
  http://oss.aliyuncs.com/aliyunecs/onekey/phpMyAdmin-4.1.8-all-languages.zip
  ${conf_wget_apr}
  ${conf_wget_aprUtil}
  ${conf_wget_webServer}
  ${conf_wget_php}
  ${conf_wget_mysql}
)


for link in ${array[*]};do
  name=${link##*/}
  if [ ! -f ${name} ];then
    wget ${link}
  fi
done

mv apr-util*.tar.gz aprUtil.tar.gz
mv apr-*.tar.gz apr.tar.gz



