#!/bin/sh

# my elementaryOS config shell script
# andy chen (bootoo@sina.cn)
# 有待完善

#安装sublime text 2
install_sublime(){
echo "install begin..."
	sudo add-apt-repository ppa:webupd8team/sublime-text-2
	sudo apt-get update
	sudo apt-get install sublime-text
	#配置sublime text

echo "install success!"
}

#安装 chrome
install_chrome(){
	wget -c -O ./Software/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
	cd ./Software
	sudo apt-get -f install
	sudo dpkg -i google-chrome.deb
}

#安装 firefox
install_firefox(){
	cd ~
	sudo apt-get install firefox
}

#安装 goagent 和 配置


#安装 重置linux文件名
reconfig_linux(){
	cd ~
	mv ./下载 Downloads
	mv ./公共的 Public
	mv ./音乐 Musics
	mv ./视频 Videos
	mv ./图片 Photos
	mv ./文档 Documents
	mv ./模板 Others
	mkdir Software

	sudo apt-get update

	# 安装纠错
	sudo apt-get -f install

	# 安装vim
	sudo apt-get install vim

	# 安装yum
	sudo apt-get install yum

	# 安装alien
	sudo apt-get install alien

	# 安装unrar
	sudo apt-get install unrar


#卸载默认浏览器
uninstall_midori(){
	echo "uninstall midori..."
	sudo apt-get autoremove midori-granite
}

#config ubuntu time function
con_time(){
  # palse use "sudo" execution

  #sudo apt-get update
  #sudo apt-get install ntpdate

  sudo rm /etc/localtime
  sudo cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  date
  sudo reboot
}

#安装 goagent 和 配置




echo '----software----------'
echo '1.chrome'
echo '2.firefox'
echo '3.sublime text'
echo '0.all'
echo '----------------------'
echo ''
read -p 'palse select option:' option

case "$option" in
	1)
	install_chrome;;
	2)
	install_firefox;;
	3)
	install_sublime;;
	0)
	reconfig_linux
	install_chrome
	install_firefox
	install_sublime
	uninstall_midori;;
esac
con_time





