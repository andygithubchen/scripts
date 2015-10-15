#!/bin/bash


#--default----------------------------------------------------------------------
mkdir ${conf_install_dir}/wwwroot/sample/

cd ${conf_install_dir}/wwwroot/sample/
echo "
<?php
  echo 'hello word !';
" > index.php
cd -

chown -R ${conf_web_group}:${conf_web_user} ${conf_install_dir}/wwwroot/


#--phpmyadmin-------------------------------------------------------------------
if [ ${conf_phpmyadmin} == 1 ];then
  cd ./download
  rm -rf phpMyAdmin-4.1.8-all-languages
  unzip phpMyAdmin-4.1.8-all-languages.zip
  mv phpMyAdmin-4.1.8-all-languages ${conf_install_dir}/wwwroot/phpmyadmin
  cd -

  chown -R ${conf_web_group}:${conf_web_user} ${conf_install_dir}/wwwroot/
  echo "| phpmyadmin-$phpmyadmin_version ok " >> tmp.log

fi
