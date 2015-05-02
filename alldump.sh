#!/bin/bash

# Title : auto mysqldump mysql databases
# Date  : Fri May  1 20:44:44 CST 2015
# Author: andychen (bootoo@sina.cn)
#
# usage:
# ./alldump.sh

USER=root
PASS=123456
HOST=192.168.73.128
DATANAME=${1}
SAVEPATH=~/

datas=$( mysql -u${USER} -p${PASS} -h${HOST} -e"show databases;" )
datas=($datas)
unset datas[0]

for dataname in ${datas[@]};do
  echo ${dataname}
  mysqldump -u${USER} -p${PASS} -h${HOST} ${dataname} > ${SAVEPATH}${dataname}.sql
done
