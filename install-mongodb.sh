#!/usr/bin/env bash

BASE_DIR=`pwd`
SCRIPT_DIR=$(readlink -e $(dirname $0))

if [ $# -gt 0 ]
then
  VERSION=$1
else
  VERSION=3.4.10
fi
MONGODB_SRC=mongodb-linux-x86_64-$VERSION.tgz
MONGODB_DIR=${MONGODB_SRC%.tgz}
HOME=/andydata/server
INSTALL_DIR=$HOME/mongodb
DATA_DIR=$INSTALL_DIR/data/mongod

if [ ! -f $MONGODB_SRC ]
then
  wget http://fastdl.mongodb.org/linux/$MONGODB_SRC
fi
if [ -d $MONGODB_DIR ]
then
  rm -rf $MONGODB_DIR
fi
tar zxf $MONGODB_SRC
cp -r $MONGODB_DIR $INSTALL_DIR

cd $SCRIPT_DIR
if [ -f conf/mongodb/mongod.cnf ]
then
  mkdir $INSTALL_DIR/conf
  cp conf/mongodb/mongod.cnf $INSTALL_DIR/conf/
  sed -i "s%\$HOME%$HOME%g" $INSTALL_DIR/conf/mongod.cnf
fi

#mkdir -p $HOME/bin
#cd $HOME/bin
#ln -sf ./mongodb/bin/mongo mongod

cd $INSTALL_DIR
mkdir -p $DATA_DIR
bin/mongod --dbpath $DATA_DIR



