#!/bin/bash

cd ./download
#--memcache ---------------------------------------------------------------------------------
rm -rf memcache
mkdir ./memcache && tar -xzvf memcache-*.tar.gz -C ./memcache --strip-components 1
cd memcache
${conf_install_dir}/server/php/bin/phpize
./configure --enable-memcache --with-php-config=${conf_install_dir}/server/php/bin/php-config
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..
echo "
[Memcache]
extension=memcache.so
" >> ${conf_install_dir}/server/php/etc/php.ini


#--redis (andychen add 2015-2-6) ------------------------------------------------------------
rm -rf redis
mkdir ./redis && tar -xzvf redis-*.tar.gz -C ./redis --strip-components 1
cd redis
${conf_install_dir}/server/php/bin/phpize
./configure --with-php-config=${conf_install_dir}/server/php/bin/php-config
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..
echo "
[Redis]
extension=redis.so
" >> ${conf_install_dir}/server/php/etc/php.ini


#--zend -------------------------------------------------------------------------------------
if ls -l ${conf_install_dir}/server/ |grep "5.3.18" > /dev/null;then

  mkdir -p ${conf_install_dir}/server/php/lib/php/extensions/no-debug-non-zts-20090626/
  mkdir ./ZendGuardLoader-glibc && tar -xzvf ZendGuardLoader-php*-${machine}.tar.gz -C ./ZendGuardLoader-glibc --strip-components 1
  mv ./ZendGuardLoader-glibc/php-5.3.x/ZendGuardLoader.so ${conf_install_dir}/server/php/lib/php/extensions/no-debug-non-zts-20090626/
  echo "zend_extension=${conf_install_dir}/server/php/lib/php/extensions/no-debug-non-zts-20090626/ZendGuardLoader.so" >> ${conf_install_dir}/server/php/etc/php.ini
  echo "zend_loader.enable=1" >> ${conf_install_dir}/server/php/etc/php.ini
  echo "zend_loader.disable_licensing=0" >> ${conf_install_dir}/server/php/etc/php.ini
  echo "zend_loader.obfuscation_level_support=3" >> ${conf_install_dir}/server/php/etc/php.ini
  echo "zend_loader.license_path=" >> ${conf_install_dir}/server/php/etc/php.ini 

elif ls -l ${conf_install_dir}/server/ |grep "5.4.23" > /dev/null;then

  mkdir -p ${conf_install_dir}/server/php/lib/php/extensions/no-debug-non-zts-20100525/
  mkdir ./ZendGuardLoader-glibc && tar -xzvf ZendGuardLoader-70429*-${machine}.tar.gz -C ./ZendGuardLoader-glibc --strip-components 1
  mv ./ZendGuardLoader-glibc/php-5.4.x/ZendGuardLoader.so ${conf_install_dir}/server/php/lib/php/extensions/no-debug-non-zts-20100525/
  echo "zend_extension=${conf_install_dir}/server/php/lib/php/extensions/no-debug-non-zts-20100525/ZendGuardLoader.so" >> ${conf_install_dir}/server/php/etc/php.ini
  echo "zend_loader.enable=1" >> ${conf_install_dir}/server/php/etc/php.ini
  echo "zend_loader.disable_licensing=0" >> ${conf_install_dir}/server/php/etc/php.ini
  echo "zend_loader.obfuscation_level_support=3" >> ${conf_install_dir}/server/php/etc/php.ini
  echo "zend_loader.license_path=" >> ${conf_install_dir}/server/php/etc/php.ini 

elif ls -l ${conf_install_dir}/server/ |grep "5.5.7" > /dev/null;then

  mkdir -p ${conf_install_dir}/server/php/lib/php/extensions/no-debug-non-zts-20121212/
  sed -i 's#\[opcache\]#\[opcache\]\nzend_extension=opcache.so#' ${conf_install_dir}/server/php/etc/php.ini
  sed -i 's#;opcache.enable=0#opcache.enable=1#' ${conf_install_dir}/server/php/etc/php.ini

fi

cd ..


