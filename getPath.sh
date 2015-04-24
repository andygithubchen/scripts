#!/bin/bash

for name in `ls /srv/svn/ | grep -v "^null_"`; do
    echo "svn://192.168.254.128/${name}" >> ./svn_path.txt
done
