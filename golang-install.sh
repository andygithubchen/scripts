#!/bin/bash

wget -c https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz

tar -C /usr/local/ -zxvf go1.8.3.linux-amd64.tar.gz

mkdir /Golang


cat >> /etc/profile <<END

export GOROOT=/usr/local/go
export GOBIN=\$GOROOT/bin
export GOPKG=\$GOROOT/pkg/tool/linux_amd64
export GOARCH=amd64
export GOOS=linux
export GOPATH=/Golang
export PATH=\$PATH:\$GOBIN:\$GOPKG:\$GOPATH/bin
END

source /etc/profile

go version
