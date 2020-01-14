#!/bin/bash

wget -c https://dl.google.com/go/go1.13.6.linux-amd64.tar.gz

tar -C /usr/local/ -zxvf go1.13.6.linux-amd64.tar.gz

#mkdir /golang
#
#cat >> /etc/profile <<END
#
#export GOROOT=/usr/local/go
#export GOBIN=\$GOROOT/bin
#export GOPKG=\$GOROOT/pkg/tool/linux_amd64
#export GOARCH=amd64
#export GOOS=linux
#export GOPATH=/golang
#export PATH=\$PATH:\$GOBIN:\$GOPKG:\$GOPATH/bin
#END


go version
