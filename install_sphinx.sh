#!/bin/bash

#安装sphinx ---------------------------------------------------------------------
fileName=sphinx-2.2.11-release
tarName=${fileName}.tar.gz

if [ ! -e $tarName ];then
  wget http://sphinxsearch.com/files/${tarName}
fi

tar -xzvf ./$tarName

cd ./${fileName}
./configure --prefix=/usr/local/sphinx/ --with-mysql --enable-id64

make && make install

cd -

#安装中文支持---------------------------------------------------------------------

fileName=coreseek-3.2.14
tarName=${fileName}.tar.gz

if [ ! -e ${tarName} ];then
  wget http://pppboy.com/wp-content/uploads/2016/02/${tarName}
fi

tar -xzvf ./${tarName}
chmod 755 ./${fileName} -R

cd ./${fileName}/mmseg-3.2.14
./bootstrap
./configure --prefix=/usr/local/mmseg3
make && make install
cd -

cd ./${fileName}/csft-3.2.14
wget -O - https://www.mawenbao.com/static/resource/sphinxexpr-gcc4.7.patch.gz | gzip -d - | patch -p0
./buildconf.sh
./configure --prefix=/usr/local/coreseek --without-unixodbc --with-mmseg --with-mmseg-includes=/usr/local/mmseg3/include/mmseg/ --with-mmseg-libs=/usr/local/mmseg3/lib/ --with-mysql
make && make install
cd -

#加入mysql的lib到ldconfig里去
echo "/andydata/server/mysql/lib" > /etc/ld.so.conf.d/mysql_lib.conf
ldconfig


#/usr/local/coreseek/bin/searchd --config /usr/local/coreseek/etc/sphinx.conf                          #开启服务
#/usr/local/coreseek/bin/searchd --config /usr/local/coreseek/etc/sphinx.conf --stop                   #停止服务
#/usr/local/coreseek/bin/indexer --config /usr/local/coreseek/etc/sphinx.conf --all --rotate           #不停止服务, 更新全部索引
#/usr/local/coreseek/bin/indexer --config /usr/local/coreseek/etc/sphinx.conf --rotate product_class   #不停止服务, 更新product_class索引


