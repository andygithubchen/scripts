#!/bin/bash

for name in /root/tj/ok/*;do
  old_name=$name
  name=${name:12:18}
  #echo $old_name
  echo $name
  #if [ $name != 'tar.sh' ];then
  #  mkdir -p ../ok/$name && tar -xzvf $old_name -C ../ok/$name --strip-components 1
  #fi
  echo $name '----' `awk '{a[$1]+=1;}END{for(i in a){print a[i]" " i;}}' $old_name/apps.mingshiedu.com.log | wc -l` >> ~/number.txt
done
