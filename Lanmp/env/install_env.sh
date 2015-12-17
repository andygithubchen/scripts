#!/bin/sh

cd ./download

rm -rf libiconv
mkdir ./libiconv && tar -xzvf libiconv-*.tar.gz -C ./libiconv --strip-components 1

cd libiconv
./configure --prefix=/usr/local
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

rm -rf zlib-1.2.3
mkdir ./zlib && tar -xzvf zlib-*.tar.gz -C ./zlib --strip-components 1
cd zlib
./configure
if [ $CPU_NUM -gt 1 ];then
    make CFLAGS=-fpic -j$CPU_NUM
else
    make CFLAGS=-fpic
fi
make install
cd ..

rm -rf freetype
mkdir ./freetype && tar -xzvf freetype-*.tar.gz -C ./freetype --strip-components 1
cd freetype
./configure --prefix=/usr/local/freetype.2.1.10
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

rm -rf libpng
mkdir ./libpng && tar -xzvf libpng-*.tar.gz -C ./libpng --strip-components 1
cd libpng
./configure --prefix=/usr/local/libpng.1.6.19
if [ $CPU_NUM -gt 1 ];then
    make CFLAGS=-fpic -j$CPU_NUM
else
    make CFLAGS=-fpic
fi
make install
cd ..

rm -rf libevent
mkdir ./libevent && tar -xzvf libevent-*.tar.gz -C ./libevent --strip-components 1
cd libevent
./configure
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

rm -rf libmcrypt
mkdir ./libmcrypt && tar -xzvf libmcrypt-*.tar.gz -C ./libmcrypt --strip-components 1
cd libmcrypt
./configure --disable-posix-threads
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
/sbin/ldconfig
cd libltdl/
./configure --enable-ltdl-install
make
make install
cd ../..

rm -rf pcre
mkdir ./pcre && tar -xzvf pcre-*.tar.gz -C ./pcre --strip-components 1
cd pcre
./configure
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install
cd ..

rm -rf jpeg
mkdir ./jpeg && tar -xzvf jpeg*.tar.gz -C ./jpeg --strip-components 1
cd jpeg
if [ -e /usr/share/libtool/config.guess ];then
cp -f /usr/share/libtool/config.guess .
elif [ -e /usr/share/libtool/config/config.guess ];then
cp -f /usr/share/libtool/config/config.guess .
fi
if [ -e /usr/share/libtool/config.sub ];then
cp -f /usr/share/libtool/config.sub .
elif [ -e /usr/share/libtool/config/config.sub ];then
cp -f /usr/share/libtool/config/config.sub .
fi
./configure --prefix=/usr/local/jpeg.9 --enable-shared --enable-static
mkdir -p /usr/local/jpeg.9/include
mkdir /usr/local/jpeg.9/lib
mkdir /usr/local/jpeg.9/bin
mkdir -p /usr/local/jpeg.9/man/man1
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install-lib
make install
cd ..

#make openssl ------------------------------------------------------------------
if [ ${conf_remake_openssl} == 1 ];then
  if [ ${ifredhat} != '' ] || [ ${ifcentos} != '' ];then
    yum -y remove openssl
  fi
  if [ ${ifubuntu} != '' ] || [ ${ifdebian} != '' ];then
    apt-get purge openssl
  fi
  rm -fr /etc/ssl

  rm -rf openssl
  mkdir ./openssl && tar -xzvf openssl-*.tar.gz -C ./openssl --strip-components 1

  cd openssl
  ./config --prefix=/usr/local/openssl --openssldir=/usr/local/ssl
  if [ $CPU_NUM -gt 1 ];then
      make -j$CPU_NUM
  else
      make
  fi
  make install_sw
  ./config shared --prefix=/usr/local/openssl --openssldir=/usr/local/ssl
  make clean
  if [ $CPU_NUM -gt 1 ];then
      make -j$CPU_NUM
  else
      make
  fi
  make install_sw
  cd ..
fi

cd ..

#load /usr/local/lib .so -------------------------------------------------------
touch /etc/ld.so.conf.d/usrlib.conf
echo "/usr/local/lib" > /etc/ld.so.conf.d/usrlib.conf
/sbin/ldconfig

#create account.log -------------------------------------------------------------
cat > account.log << END
##########################################################################
# 
# thank you for using aliyun virtual machine
# 
##########################################################################

FTP:
account:www
password:ftp_password

MySQL:
account:root
password:mysql_password
END


