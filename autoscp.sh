#!/bin/bash

# Title : auto copy files to remote
# Date  : Sat May  2 14:54:10 CST 2015
# Author: andychen (bootoo@sina.cn)
#
# Usage :
# ./autoscp.sh file 1  #copy to remote (file 不能有文件的/,而且要和autoscp.sh在同级目录)
# ./autoscp.sh file 0  #copy to local

USER=user
PASS=passwd
HOST=remote_ip
FILE=${1}
TYPE=${2}

REMOTE_PATH=/root/
LOCAL_PATH=~/scp/

# check
if [ $# != 2 ];then
  echo "+-----------------------------------------------------+"
  echo "| error!                                              |"
  echo "|-----------------------------------------------------|"
  echo "|                                                     |"
  echo "| Usage:                                              |"
  echo "| ./autoscp.sh file 1                                 |"
  echo "| or                                                  |"
  echo "| ./autoscp.sh file 0                                 |"
  echo "+-----------------------------------------------------+"
  exit 0
fi

if [ ${TYPE} != 1 ]&&[ ${TYPE} != 0 ];then
  echo "+-----------------------------------------------------+"
  echo "| you input this type is error!                       |"
  echo "+-----------------------------------------------------+"
  exit 0
fi

if [ ${TYPE} = 1 ]&&[ ! -e ${FILE} ];then
  echo "+-----------------------------------------------------+"
  echo "| you input this file is not found!                   |"
  echo "+-----------------------------------------------------+"
  exit 0
fi


# copy to remote
if [ ${TYPE} = 1 ];then
  if [ -d ${FILE} ];then
    tar -zvcf ${FILE}.tar.gz ${FILE}
    FILE=${FILE}.tar.gz
  fi
  scp ${FILE} ${USER}@${HOST}:${REMOTE_PATH}
  ssh ${USER}@${HOST} "cd ~; ./untar.sh ${FILE}"
  rm -f ./${FILE}
  exit 0
fi


# copy to local
if [ ${TYPE} = 0 ];then
  mkdir -p ${LOCAL_PATH}
  scp ${USER}@${HOST}:${REMOTE_PATH}${FILE} ${LOCAL_PATH}
  exit 0
fi



