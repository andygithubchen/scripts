#!/bin/bash

cd ./download
rm -fr ./${mysql_dir}
mkdir ./${mysql_dir} && tar -zxvf ${mysql_dir}*.tar.gz -C ./${mysql_dir} --strip-components 1
mv ${mysql_dir}/* ${conf_install_dir}/server/mysql
cd -


groupadd mysql
useradd -g mysql -s /sbin/nologin mysql

${conf_install_dir}/server/mysql/scripts/mysql_install_db --datadir=${conf_install_dir}/server/mysql/data/ --basedir=${conf_install_dir}/server/mysql --user=mysql
chown -R mysql:mysql ${conf_install_dir}/server/mysql/
chown -R mysql:mysql ${conf_install_dir}/server/mysql/data/
chown -R mysql:mysql ${conf_install_dir}/log/mysql
\cp -f ${conf_install_dir}/server/mysql/support-files/mysql.server /etc/init.d/mysqld
sed -i 's#^basedir=$#basedir='${conf_install_dir}'/server/mysql#' /etc/init.d/mysqld
sed -i 's#^datadir=$#datadir='${conf_install_dir}'/server/mysql/data#' /etc/init.d/mysqld
\cp -f ${conf_install_dir}/server/mysql/support-files/my-medium.cnf /etc/my.cnf
sed -i 's#skip-locking#skip-external-locking\nlog-error='${conf_install_dir}'/log/mysql/error.log#' /etc/my.cnf
chmod 755 /etc/init.d/mysqld
/etc/init.d/mysqld start
