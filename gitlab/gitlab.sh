#!/bin/bash

#yum install -y curl policycoreutils-python openssh-server cronie lokkit
#
#yum install postfix
#service postfix start
#chkconfig postfix on
#
#
#curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
#echo 'config gitlab_gitlab-ee.repo ============='
#echo ''
#echo '[gitlab_gitlab-ee]
#name=gitlab_gitlab-ee
#baseurl=https://mirrors.tuna.tsinghua.edu.cn/gitlab-ee/yum/el7
#repo_gpgcheck=0
#gpgcheck=1
#enabled=1
#gpgkey=https://packages.gitlab.com/gitlab/gitlab-ee/gpgkey
#       https://packages.gitlab.com/gitlab/gitlab-ee/gpgkey/gitlab-gitlab-ee-3D645A26AB9FBD22.pub.gpg
#sslverify=1
#sslcacert=/etc/pki/tls/certs/ca-bundle.crt
#metadata_expire=300
#'


#EXTERNAL_URL="http://git.sl-xyjgx.com" yum -y install gitlab-ee --nogpgcheck


#问题 =========================================================================================

# 1. 在卸载gitlab然后再次安装执行sudo gitlab-ctl reconfigure的时候往往会出现：ruby_block[supervise_redis_sleep] action run，会一直卡无法往下进行！
# 
# 按住CTRL+C强制结束 
# 运行：sudo systemctl restart gitlab-runsvdir 
# 再次执行：sudo gitlab-ctl reconfigure



# 2. gitlab 使用自己的nginx
# 
# usermod -G gitlab-www www
# gitlab-ctl stop
# 
# 
# vi /etc/gitlab/gitlab.rb
# nginx['enable'] = false # 设置为false
# web_server['external_users'] = ['www']
# sudo gitlab-ctl reconfigure
# gitlab-ctl start


#初始账号
#root
#你重置的密码
