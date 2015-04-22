#!/bin/bash

# build new repository for SVN
# andychen (bootoo@sina.cn)


# === by ubuntu ===============================================================================
byUbuntu(){
  if [ ! -d "/srv/svn/" ];then
    echo ''
    echo '  +--------------------------------------------+'
    echo '  | you could no install SVN !                 |'
    echo '  | you can use install.sh file install SVN !  |'
    echo '  +--------------------------------------------+'
    echo ''
    exit 0
  fi

  cd /srv/svn

  # --- config new repository ---
  i=0
  for name in `ls ${1}`;do
    null_rep=null_${i}
    conf_new_rep ${null_rep} ${name}

    # --- check input users ---
    check_users dev $null_rep
    check_users tes $null_rep

    ((i++))
  done
}


conf_new_rep(){

  #sudo mv $1 $new_name
  sudo mv $1 $2
  # --- edit svnserve.conf and authz file ---
  sed -i "s/$1/$2/" ./$2/conf/svnserve.conf
  sed -i "s/$1/$2/g" ./conf/authz
  echo $2
}


# === check input users ===
# check input users
# @param  $1=>dev[or tes]
# @param  $2=>$name
# @return $new_name
check_users(){
#  typ='tests'
#  if [ "$1" = 'dev' ]; then
#    typ='developments'
#  fi
#  echo "input your item $typ user name and password"
#  echo 'example "usr1-pwd1,usr2-pwd2,..."'
#  read -p 'input:' users
#
#  if [ "$users" = 'q' ]; then
#    exit 0  #///////////////////////////////////////////////////////////////////////////////////////////////
#  fi
#
#  if [ -z "$users" ]; then
#    echo ''
#    echo 'you input anything!'
#    echo ''
#    check_users $1
#  fi
#
#  arr=$(strToarray , $users)
#  if [ "${#arr[@]}" -le 0 ]; then
#    echo ''
#    echo 'input error! try again'
#    echo ''
#    check_users $1
#  fi
#
#  for s in $arr; do
#    str=$(echo "$s" | awk '/^([0-9a-zA-Z]+)-([0-9a-zA-Z]+)$/')  # ///////////////////////////////////////////////
#    len=${#str}
#    if [ "$len" -le 0 ]; then
#      echo ''
#      echo 'input users error, please try again!'
#      echo ''
#      break
#      check_users $1
#    fi
#  done
#  # --- Check if the user already exists ---
#  for uStr in $arr; do
#    uArr=$(strToarray - $uStr)
#    uArr=($uArr)
#    uName=${uArr[0]}
#    have=$(grep -w $uName /srv/svn/conf/passwd)
#    if [ "$have" ]; then
#      echo ''
#      echo 'the user already exists, try again'
#      echo ''
#      check_users $1
#    fi
#  done

  # --- edit passwd file ---
  users=andychen-123456,atom-123456
  arr=$(strToarray , $users)
  num=${2##*_}
    #user_0 = 123456
    #user_0_tes = 123456
  users_str=''
  for uStr in $arr; do
    uArr=$(strToarray -, ${uStr})
    uArr=($uArr)
    uName=${uArr[0]}
    uPawd=${uArr[1]}
    sed -i "/${num}_tes/a\\${uName} = ${uPawd}" ./conf/passwd
    users_str+=$uName', '
  done
  users_str=${users_str%,*}

  # --- edit authz  file ---
  re_str="user_${num}_tes"
  if [ "$1" = 'dev' ]; then
    re_str="user_${num}"
  fi

  sed -i "s/${re_str}$/${users_str}/" ./conf/authz
  #grounp_null_0_dev = user_0
  #grounp_null_0_tes = user_0_tes
}


# ---------------------------------------------------------------------------------------------------------------------

# === string to array function ===
# string to array
# @param $1 IFS
# @param $2 string
strToarray(){
  LD_IFS="$IFS"
  IFS="$1"
  arr=($2)
  IFS="$OLD_IFS"
  echo ${arr[@]}
}

# === by centos ===============================================================================
byCentos(){
  echo "byCentos,developments....."
}







# === build view ==============================================================================
echo ''
echo '------------- build new repository for SVN -------------'
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




