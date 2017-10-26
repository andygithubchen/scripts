#!/bin/bash

etcDir=/etc/init.d/
serverDir=/andydata/server/

N=1
arr=
phps=`ls $serverDir | grep "php-"`

for i in $phps; do
  echo $N ')' $i
  arr[$N]=$i
  let N+=1
done

read -p "select : " number
newVer=$etcDir"php-fpm_"${arr[$number]}

if [ -f $newVer ]; then
  ${etcDir}php-fpm stop

  #替换启动脚本
  cp $newVer ${etcDir}php-fpm

  #替换PHP文件夹软链接
  rm -fr /andydata/server/php
  ln -s /andydata/server/${arr[$number]} /andydata/server/php

  service php-fpm start
  ${etcDir}php-fpm restart
  systemctl daemon-reload
  echo "change success !"
else
  echo ${arr[$number]}"is runing"
fi
echo ""



