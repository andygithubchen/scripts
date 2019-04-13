#!/usr/bin/env bash

BASE_DIR=`pwd`
SCRIPT_DIR=$(readlink -e $(dirname $0))

GEARMAN_SRC=gearmand-1.1.8.tar.gz
GEARMAN_DIR=${GEARMAN_SRC%.tar.gz}
INSTALL_DIR=/usr/local/gearman
DATA_DIR=$INSTALL_DIR/data

sudo apt-get update
sudo apt-get install libgearman-dev boost boost-devel libevent libevent-devel sqlite sqlite-devel gperf uuid uuid-devel libuuid libuuid-devel libboost-all-dev

cd $BASE_DIR
if [ ! -f $GEARMAN_SRC ];then
  wget https://launchpadlibrarian.net/141833462/$GEARMAN_SRC
fi
if [ -d $GEARMAN_DIR ];then
  rm -rf $GEARMAN_DIR
fi

tar zxf $GEARMAN_SRC
cd $GEARMAN_DIR
mkdir -p $INSTALL_DIR
./configure --prefix=$INSTALL_DIR --with-mysql=/xhdata/server/mysql/bin/mysql_config
make
make install
cd -

mkdir -p $INSTALL_DIR/var/log/
cd $INSTALL_DIR/var/log/
sudo touch gearmand.log
chmod 777 gearmand.log
cd -

cp $INSTALL_DIR/sbin/gearmand /usr/local/bin

gearmand -d


