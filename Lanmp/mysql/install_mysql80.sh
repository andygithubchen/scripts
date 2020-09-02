#!/bin/bash

apt-get install libncurses5-dev -y

dir=${conf_install_dir}/server/mysql

cd ./download
rm -fr ./${mysql_dir}
mkdir ./${mysql_dir} && tar -zxvf mysql-boost-8.0.21.tar.gz -C ./${mysql_dir} --strip-components 1
rm -fr ${dir}/*
cd -

cd ./download/${mysql_dir}
cmake . \
	-DCMAKE_INSTALL_PREFIX=${dir} \
	-DMYSQL_UNIX_ADDR=${dir}/run/mysql.sock \
	-DSYSCONFDIR=${dir}/etc \
	-DSYSTEMD_PID_DIR=${dir}/run \
	-DMYSQL_DATADIR=${dir}/data \
	-DDOWNLOAD_BOOST=1 \
	-DWITH_BOOST=boost \
	-DFORCE_INSOURCE_BUILD=1 \
	-DWITH_SYSTEMD=1 

if [ $CPU_NUM -gt 1 ];then
	make -j$CPU_NUM
else
	make
fi

make install
cd -
exit 1

${dir}/bin/mysqld --defaults-file=/etc/my.cnf --initialize --user=mysql --basedir=${dir} --datadir=${dir}/data 


groupadd mysql
useradd -g mysql -s /sbin/nologin mysql

chown -R mysql:mysql ${dir}/
chown -R mysql:mysql ${dir}/data/
chown -R mysql:mysql ${conf_install_dir}/log/mysql
\cp -f ${mysql_dir}/support-files/mysql.server /etc/init.d/mysqld
sed -i 's#^basedir=$#basedir='${dir}'#' /etc/init.d/mysqld
sed -i 's#^datadir=$#datadir='${dir}'/data#' /etc/init.d/mysqld

#\cp -f ${conf_install_dir}/server/mysql/support-files/my-medium.cnf /etc/my.cnf
#sed -i 's#skip-locking#skip-external-locking\nlog-error='${conf_install_dir}'/log/mysql/error.log#' /etc/my.cnf
chmod 755 /etc/init.d/mysqld
/etc/init.d/mysqld start
