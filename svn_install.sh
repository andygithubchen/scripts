#!/bin/bash

# set up item SVN service for shell script
# author andy chen
# email  bootoo@sina.cn


# === set up for Ubuntu ========================================================================
byUbuntu(){
	#sudo apt-get update
	#sudo apt-get install subversion
	cd /srv
	sudo mkdir svn
	cd ./svn

  # --- build conf file and child files authz,passwd ------------------
  cd /srv/svn/
  sudo mkdir conf
  sudo touch ./conf/authz ./conf/passwd

  # --- build user groups ---------------------------------------------
  echo "
[aliases]
# joe = /C=XZ/ST=Dessert/L=Snake City/O=Snake Oil, Ltd./OU=Research Institute/CN=Joe Average

[groups]
admin = admin,boss
"	> /srv/svn/conf/authz

  # --- build users and password --------------------------------------
	echo "
[users]
admin = 123456
boss  = 135246
"	> /srv/svn/conf/passwd

  # --- create null repository -------------------------------------
  file_num=100
  rep_name=null_
  for((i=0; i<$file_num; i++)); do
    sudo svnadmin create ${rep_name}$i
    sudo rm ./${rep_name}$i/conf/authz
    sudo rm ./${rep_name}$i/conf/passwd
    editSvnserve $i
    editAuthz $i
    echo -e "\nuser_$i = 123456\nuser_${i}_tes = 123456" >> ./conf/passwd
    num=$((file_num - i - 1))
    sed -i "/boss/a\ \ngrounp_${rep_name}${num}_dev = user_${num}\ngrounp_${rep_name}${num}_tes = user_${num}_tes" ./conf/authz
  done

  # --- start svnserve ------------------------------------------------
  sudo svnserve -d -r /srv/svn
  echo ''
  echo 'succeed!!!'
  echo 'use create.sh build your new repository'
  echo ''
  echo 'builded 10 SVN repository:'
  find ./ -name "${rep_name}*" | sort
  echo ''
}

# --- edit svnserve.conf file -----------------------------------------
editAuthz(){
  echo "
[${rep_name}$1:/]
@admin = rw
@grounp_${rep_name}$1_dev = rw
@grounp_${rep_name}$1_tes = r
*=r
"	>> /srv/svn/conf/authz
}

# --- edit svnserve.conf file -----------------------------------------
editSvnserve(){
	echo "
[general]
anon-access = none
auth-access = write
password-db = /srv/svn/conf/passwd
authz-db = /srv/svn/conf/authz
realm = ${rep_name}$1
# force-username-case = none

[sasl]
# use-sasl = true
# min-encryption = 0
# max-encryption = 256
"	> /srv/svn/${rep_name}$1/conf/svnserve.conf

}


# === set up for Ubuntu =======================================================================
byCentos(){
  echo ''
	echo "byCentos,developing......."
  echo ''
}


# === install view  ===========================================================================
echo ''
echo '------------- begin set up SVN -------------'
echo ''
echo '1.Ubuntu'
echo '2.Centos'
echo ''
read -p 'palse select option:' option

case "$option" in
	1)
		byUbuntu;;
	2)
		byCentos;;
	*)
		echo ''
		echo "select error!!"
		echo '';;
esac

