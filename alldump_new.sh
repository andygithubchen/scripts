#!/bin/bash

# Title : auto mysqldump mysql databases
# Date  : Tue Apr 23 20:03:59 CST 2024
# Author: andychen (bootoo@sina.cn)
#
# usage:
# ./alldump_new.sh

USER=root
PASS=''
HOST=127.0.0.1
DATA=/data/center_mysql_backup
MAX=3 #备份文件保留个数，超过就会清除最早备份的

FILE=$(date +'%Y-%m-%d')
TIME=$(date +'%H.%M')
NAME=${FILE}_${TIME}
SAVEPATH=${DATA}/${NAME}


#clean
len=$(ls ${DATA} | wc -l)
if [ "$len" -gt "$MAX" ]; then
  del=0
  number=$(expr $len - $MAX)
  for dir in `ls ${DATA}`; do
    if [ "$del" -ge "$number" ]; then
      break
    fi

    ((del++))
    rm -fr ${DATA}/${dir}
  done
fi

mkdir -p ${SAVEPATH}

#backup
datas=$( mysql -u${USER} -p${PASS} -h${HOST} -e"show databases;" )
datas=($datas)
unset datas[0]

for dataname in ${datas[@]};do
  mysqldump --single-transaction --no-tablespaces -u${USER} -p${PASS} -h${HOST} ${dataname} > ${SAVEPATH}/${dataname}.sql
done

cd ${DATA}
size=$(du -s ${NAME} | awk '{print $1}')
if [ "$size" -gt 400 ]; then
  tar -czvf ${NAME}.tar.gz ./${NAME} >>/dev/null
fi
rm -fr ./${NAME}
cd -




