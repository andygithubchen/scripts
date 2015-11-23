#/bin/bash/

# Title : clear bad files
# Date  : Sat Apr 11 19:05:12 CST 2015
# Author: andychen (bootoo@sina.cn)

#要备份的项目所在路径
itemPath=/home/www/ 

#备份文件的存放路径
itemPath=/home/andy/backup

cd ${itemPath}

year=`date +"%Y"`
month=`date +"%m"`
day=`date +"%d"`

mkdir -p ${itemPath}/${year}/${month}/${day}


for file in `ls`; do
     tar -zcvf ${itemPath}/${year}/${month}/${day}/${file}.tar.gz ${file}
done 


cd - >> /dev/null


# at 4 a.m every day with:
# m h dom mon dow   command
# 0 4 * * * /home/andy/crontab.sh
