#!/bin/bash

# PHP 性能追踪及分析工具 xhprof 的安装与使用

tmpFile=tmp234
mkdir ./$tmpFile
cd ./$tmpFile

#安装xhprof PHP扩展
git clone https://github.com/phacility/xhprof.git
cd ./xhprof/extension
phpize
./configure --with-php-config=/andydata/server/php/bin/php-config --enable-xhprof
service php-fpm stop
make && make install
echo "[xhprof]" >> /andydata/server/php/etc/php.ini
echo "extension=Xhprof.so" >> /andydata/server/php/etc/php.ini
cd -

#安装mongodb PHP扩展
pecl install mongodb
echo "[mongo]" >> /andydata/server/php/etc/php.ini
echo "extension=mongodb.so" >> /andydata/server/php/etc/php.ini

#安装mongodb 数据库
~/coding/other/install-mongodb.sh
echo '================================================================='
echo "create mongodb table"
echo "$ /usr/local/mongodb/bin/mongo"
echo "> use xhprof"
echo "db.results.ensureIndex( { 'meta.SERVER.REQUEST_TIME' : -1 } )  "
echo "db.results.ensureIndex( { 'profile.main().wt' : -1 } )  "
echo "db.results.ensureIndex( { 'profile.main().mu' : -1 } )  "
echo "db.results.ensureIndex( { 'profile.main().cpu' : -1 } )  "
echo "db.results.ensureIndex( { 'meta.url' : 1 } )  "
echo '================================================================='


#部署xhgui项目
cd /andydata/wwwroot/
git clone https://github.com/maxincai/xhgui.git
chown www:www ./xhgui -R
chmod -R  755 ./xhgui
echo "========= config nginx item for xhgui now ============"
echo ''
echo '有时要在/xhgui/external/header.php 111行处加这些：'
echo '|$profile = [];'
echo '|foreach($data['profile'] as $key => $value) {'
echo '|  $profile[strtr($key, ['.' => '_'])] = $value;'
echo '|}'
echo '|$data['profile'] = $profile;'
echo ''



