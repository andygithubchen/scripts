#/bin/bash/

# Title : clear bad files (cdf)
# Date  : Sat Apr 11 19:05:12 CST 2015
# Author: andychen (bootoo@sina.cn)

storePath='/home/andy/backup/badFiles/'
mkdir -p $storePath
pwd=`pwd`
pwd=${pwd/\//from_}


# 检查输入（不可以有两级路径）
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
    echo '+-------------------------- +'
    echo '| input error               |'
    echo '+-------------------------- +'
    exit 0
  fi

  cd ${storePath}
  mkdir -p './'${pwd}
  cd - >> /dev/null

  here=${storePath}${pwd}

  fName=${file/.\//}
  fName=${fName/\//}

  # 检查同名文件是否已经存在
  if [ -e ${here}/${fName} ]; then
     cd ${here}

     order=0
     lss=(`ls | grep "^\${fName}[0-9]"`)
     if [ ${lss} ]; then
       num=${#lss[@]}
       last=${lss[${num} - 1]}
       last=${last/${fName}/}
       order=$(( ${last} + 1 ))
     fi

     cd - >> /dev/null
     mv -f ${file} ${here}/${fName}${order}
  else
     mv -f ${file} ${here}
  fi

done


