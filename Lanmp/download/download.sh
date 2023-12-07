#!/bin/bash

array=(
  https://support.edokumenty.eu/download/installation/linux-os/ZendGuardLoader-70429-PHP-5.4-linux-glibc23-x86_64.tar.gz
  http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz
  https://src.fedoraproject.org/repo/pkgs/zlib/zlib-1.2.3.tar.gz/debc62758716a169df9f62e6ab2bc634/zlib-1.2.3.tar.gz
  https://download-mirror.savannah.gnu.org/releases/freetype/freetype-old/freetype-2.1.10.tar.gz
  https://distfiles.macports.org/libevent/libevent-1.4.14b-stable.tar.gz
  https://src.fedoraproject.org/repo/pkgs/libmcrypt/libmcrypt-2.5.8.tar.gz/0821830d930a86a5c69110837c55b7da/libmcrypt-2.5.8.tar.gz
  https://directadmin.spd.co.il/customapache/pcre-8.12.tar.gz
  https://mirror.sobukus.de/files/src/libpng/libpng-1.6.19.tar.gz
  http://www.ijg.org/files/jpegsrc.v9a.tar.gz
  https://ftp.openssl.org/source/old/1.0.0/openssl-1.0.0c.tar.gz
  ${conf_wget_apr}
  ${conf_wget_aprUtil}
  ${conf_wget_webServer}
  ${conf_wget_php}
  ${conf_wget_mysql}
)


for link in ${array[*]};do
  wget -c ${link}
done

mv apr-util*.tar.gz aprUtil.tar.gz
mv apr-*.tar.gz apr.tar.gz



