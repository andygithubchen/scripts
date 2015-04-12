#/bin/bash/

# Title : clear bad files (cdf)
# Date  : Sat Apr 11 19:05:12 CST 2015
# Author: andychen (bootoo@sina.cn)

storePath='/home/andy/backup/badFiles/'
mkdir -p $storePath
pwd=`pwd`
pwd=${pwd/\//from_}

check(){
  num=`echo ${1} | awk -F/ '{print NF}'`
  if [ $num -gt 2 ]; then

    if [ $num -gt 2 ]; then
      return 0
    fi

    num=`echo ${1} | awk -F./ '{print NF}'`
    if [ $num -ne 2 ]; then
      return 0
    fi

  fi

  return 1
}


for file in $@; do
  check ${file}
  res=$?
  if [ ${res} != 1 ]; then
    exit 0
  fi

  cd ${storePath}
  mkdir -p './'${pwd}
  cd - >> /dev/null

  here=${storePath}${pwd}

  cp ${file} ${here}

  #if [ -d ${file} ]; then
  #  mv -fr ${file} ${here}
  #else
  #  mv -f ${file} ${here}
  #fi

done












