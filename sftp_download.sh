#!/bin/bash

# Title : download files from remote dy sftp
# Date  : Sun Apr 19 21:04:46 CST 2015
# Author: andychen (bootoo@sina.cn)


HOST=youhost
USER=user
PASS=youpassword
echo ''
echo "+----------------- get from ${HOST} ------------------------+"
echo ''
lftp -u ${USER},${PASS} sftp://${HOST} <<EOF
  get ${1} ${2}
  bye
EOF
echo ''
echo "+----------------- done -------------------------------------------+"
echo ''


#sftp root@120.24.160.149 <<EOF
#  get /root/atomic    ./
#EOF

