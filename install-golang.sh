#!/bin/bash


_source(){
  wget -c https://dl.google.com/go/go1.13.linux-amd64.tar.gz

  tar -C /usr/local/ -zxvf go1.13.linux-amd64.tar.gz

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
}

_apt(){
  #ubuntu 16
  sudo add-apt-repository ppa:longsleep/golang-backports
  sudo apt-get update
  sudo apt-get install golang-go

  #centOS
  #yum install epel -y
  #yum install go -y



  cat >> /etc/profile <<END

  export GOROOT=/usr/lib/go
  export GOBIN=/usr/bin
  export PATH=$PATH:$GOBIN:$GOROOT
END
}

_source
source /etc/profile

go version
