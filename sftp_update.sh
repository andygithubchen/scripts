#!/bin/bash

# Title : clear bad files (cdf)
# Date  : Sun Apr 19 21:04:56 CST 2015
# Author: andychen (bootoo@sina.cn)


# 参数 ==================================================================
HOST=youhost
USER=user
PASS=youpassword
GOAL=/root
ITEM=youitem
ITEM_TAR=${ITEM}.tar.gz


# 压缩项目 ==============================================================
tar -zvcf ./${ITEM_TAR} ./${ITEM}

# 上传项目 ==============================================================
echo ''
echo "+----------------- pull from ${HOST} -----------------------+"
echo ''
lftp -u ${USER},${PASS} sftp://${HOST} <<EOF
  put ./${ITEM_TAR} ${GOAL}
  bye
EOF
echo ''
echo "+----------------- done -------------------------------------------+"
echo ''

#ssh roo@${HOST}
#  cd ${GOAL}
#  mv ${ITEM_TAR} ${ITEM}_new.tar.gz
#"

# 删除项目压缩包 ========================================================
rm -f ./${ITEM_TAR}




#sftp root@120.24.160.149 <<EOF
#  put ./my.txt    /root
#EOF

