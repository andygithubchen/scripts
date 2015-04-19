#!/bin/bash

# Title : clear bad files (cdf)
# Date  : Sun Apr 19 21:05:06 CST 2015
# Author: andychen (bootoo@sina.cn)


HOST=youhost
USER=user
PASS=youpassword
echo ''
echo "+----------------- pull from ${HOST} -----------------------+"
echo ''
lftp -u ${USER},${PASS} sftp://${HOST} <<EOF
  put ${1} ${2}
  bye
EOF
echo ''
echo "+----------------- done -------------------------------------------+"
echo ''


#sftp root@120.24.160.149 <<EOF
#  put ./my.txt    /root
#EOF

