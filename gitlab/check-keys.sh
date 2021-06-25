#/bin/bash


target=u3d-2-game


for((i=1;i<=1000;i++));
do
  json=$(curl -s --header "Authorization: Bearer 85a22b8a0c230e4532db1991c320ae3c18f1414c1f4769bbfe9894eda97d23cc" http://git.shenlongyx.com/api/v4/keys/$i)
  echo $json | grep $target
  if [[ $? -eq 0 ]]; then
    echo $i
    echo
    break
  fi
done
