#/bin/bash/

# Title : clear bad files 
# Date  : Sat Apr 11 19:05:12 CST 2015
# Author: andychen (bootoo@sina.cn)

echo ${1}
echo ${2}

cd ${1}
file2=(`ls`)
echo ${file2[*]}
cd - >> /dev/null

cd ${2}
file3=(`ls`)
echo ${file3[*]}
cd - >> /dev/null
