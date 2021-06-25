#!/bin/bash

# Title : auto copy files to local
# Date  : Sat May  2 14:54:10 CST 2015
# Author: andychen (bootoo@sina.cn)

USER=root
PASS=password
HOST=serverIp
PORT=40022

YEAR=`date +"%Y"`
MONTH=`date +"%m"`
DAY=`date +"%d"`

REMOTE_PATH=/home/andy/backup/${YEAR}/${MONTH}/${DAY}
LOCAL_PATH=/home/andy/backup/from84/${YEAR}/${MONTH}/${DAY}

mkdir -p ${LOCAL_PATH}

data=`ssh ${USER}@${HOST} -p${PORT} "ls ${REMOTE_PATH}"`

for file in ${data[*]};do
  scp -P ${PORT} ${USER}@${HOST}:${REMOTE_PATH}/${file} ${LOCAL_PATH} >>/dev/null
done




