#!/bin/bash

# Title : auto mysqldump mysql databases
# Date  : Fri May  1 20:44:44 CST 2015
# Author: andychen (bootoo@sina.cn)
#
# use:
# ./autodump.sh dataname
# or
# ./autodump.sh dataname new_dataname

USER=root
PASS=123456
HOST=192.168.73.128
DATANAME=${1}
SAVEPATH=./

if [ ! -z ${2} ];then
#if [ ${2} != '' ];then
  DATANAME_NEW=${2}.sql
else
  DATANAME_NEW=${DATANAME}_`date +%Y-%m-%d`.sql
fi



echo ''
echo "+----------------- auto mysqldump  ------------------------+"
echo '|'
echo '| dump...'
mysqldump -u${USER} -p${PASS} -h${HOST} ${DATANAME} > ${SAVEPATH}${DATANAME_NEW}
echo '|'
echo "+----------------- done -------------------------------------------+"
echo ''


