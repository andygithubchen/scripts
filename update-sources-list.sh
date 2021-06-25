#!/bin/bash

file=/etc/apt/sources.list

updateList(){
  cat >> ${file} <<END

#搜狐更新服务器 (山东联通千兆接入)
deb http://mirrors.sohu.com/ubuntu/ vivid main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ vivid-security main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ vivid-updates main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ vivid-proposed main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ vivid-backports main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ vivid main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ vivid-security main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ vivid-updates main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ vivid-proposed main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ vivid-backports main restricted universe multiverse

#中国科学技术大学更新服务器  (位于合肥，千兆教育网接入，百兆电信/联通线路智能路由）
deb http://debian.ustc.edu.cn/ubuntu/ vivid main multiverse restricted universe
deb http://debian.ustc.edu.cn/ubuntu/ vivid-backports main multiverse restricted universe
deb http://debian.ustc.edu.cn/ubuntu/ vivid-proposed main multiverse restricted universe
deb http://debian.ustc.edu.cn/ubuntu/ vivid-security main multiverse restricted universe
deb http://debian.ustc.edu.cn/ubuntu/ vivid-updates main multiverse restricted universe
deb-src http://debian.ustc.edu.cn/ubuntu/ vivid main multiverse restricted universe
deb-src http://debian.ustc.edu.cn/ubuntu/ vivid-backports main multiverse restricted universe
deb-src http://debian.ustc.edu.cn/ubuntu/ vivid-proposed main multiverse restricted universe
deb-src http://debian.ustc.edu.cn/ubuntu/ vivid-security main multiverse restricted universe
deb-src http://debian.ustc.edu.cn/ubuntu/ vivid-updates main multiverse restricted universe

#阿里云更新服务器（北京万网/浙江杭州阿里云服务器双线接入）
deb http://mirrors.aliyun.com/ubuntu/ vivid main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ vivid-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ vivid-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ vivid-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ vivid-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ vivid main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ vivid-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ vivid-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ vivid-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ vivid-backports main restricted universe multiverse

deb https://packagecloud.io/amjith/mycli/ubuntu/ trusty main

END
}


if [ -f ${file} ];then
  updateList
  echo 'done'
else
  echo 'no file: '${file}
fi




