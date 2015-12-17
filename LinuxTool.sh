#!/bin/bash

sudo update
sudo apt-get install -y htop unzip zip rar tree sl cmatrix libaa-bin
sudo apt-get install -y mycli #不一定安装成功


# ASCII字符水族馆动画
sudo apt-get installlibcurses-perl

wget http://search.cpan.org/CPAN/authors/id/K/KB/KBAUCOM/Term-Animation-2.4.tar.gz
tar -zxvf Term-Animation-2.4.tar.gz
cd Term-Animation-2.4/
perl Makefile.PL && make && make test
sudo make install
cd -
rm -fr ./Term-Animation-2.4*

wget http://www.robobunny.com/projects/asciiquarium/asciiquarium.tar.gz
tar -zxvf asciiquarium.tar.gz
cd asciiquarium_1.1/
sudo cp asciiquarium /usr/local/bin
sudo chmod 0755 /usr/local/bin/asciiquarium
cd -
rm -fr ./asciiquarium*



