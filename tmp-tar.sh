#!/bin/bash

for name in ./*;do
  old_name=$name
  name=${name:2:8}
  if [ $name != 'tar.sh' ];then
    mkdir -p ../ok/$name && tar -xzvf $old_name -C ../ok/$name --strip-components 1
  fi
done
