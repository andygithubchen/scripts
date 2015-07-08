#!/bin/bash


ifrpm=$(cat /proc/version | grep -E "redhat|centos")
ifdpkg=$(cat /proc/version | grep -Ei "ubuntu|debian")
ifcentos=$(cat /proc/version | grep centos)

if [ "$ifrpm" != "" ];then
	yum -y install vsftpd
	\cp -f ./ftp/config-ftp/rpm_ftp/* /etc/vsftpd/
else
	apt-get -y install vsftpd
	if cat /etc/shells | grep /sbin/nologin ;then
		echo ""
	else
		echo /sbin/nologin >> /etc/shells
	fi
	\cp -fR ./ftp/config-ftp/apt_ftp/* /etc/
fi

if [ "$ifcentos" != "" ] && [ "$machine" == "i686" ];then
    rm -rf /etc/vsftpd/vsftpd.conf
	\cp -f ./ftp/config-ftp/vsftpdcentosi686.conf /etc/vsftpd/vsftpd.conf
fi

/etc/init.d/vsftpd start

chown -R ${conf_web_group}:${conf_web_user} ${conf_install_dir}/wwwroot

#bug kill: '500 OOPS: vsftpd: refusing to run with writable root inside chroot()'
chmod a-w ${conf_install_dir}/wwwroot

MATRIX="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
LENGTH="9"
while [ "${n:=1}" -le "$LENGTH" ]
do
	PASS="$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}"
	let n+=1
done
if [ "$ifrpm" != "" ];then
  echo $PASS | passwd --stdin ${conf_web_user}
else
  echo "${conf_web_user}:$PASS" | chpasswd
fi

sed -i s/'ftp_password'/${PASS}/g account.log


