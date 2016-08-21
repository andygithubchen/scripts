#!/bin/bash

sudo update
sudo apt-get install -y htop          #替代top的
sudo apt-get install -y unzip zip rar #各种压缩工具
sudo apt-get install -y tree          #查看文件结构的
sudo apt-get install -y sl cmatrix    #无聊的动画
sudo apt-get install -y ccze          #查看日志时带颜色输出
sudo apt-get install -y nmon saidar glances dstat        #显示系统性能信息的工具
sudo apt-get install -y ncdu          #查看文件夹大小
sudo apt-get install -y inxi          #查看系统信息
sudo apt-get install -y libaa-bin     #其他

sudo apt-get install -y python-pip    #有提示的MySQL命令行客户端
sudo pip install mycli


#-- ASCII字符水族馆动画
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



