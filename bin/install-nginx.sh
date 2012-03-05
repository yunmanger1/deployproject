#!/bin/bash

pwd=$( readlink -f "$( dirname "$BASH_SOURCE" )" )
source $pwd/startwork

if [ ! $1 ]
then
  PKG_DIR=$pwd/../pkg
else
  PKG_DIR=$1
fi

cd $PKG_DIR

uwsgi_pack=uwsgi-1.0.4
nginx_pack=nginx-1.0.12
pcre_pack=pcre-8.21
user=$(whoami)
group=$(whoami)

if [ ! -e ${uwsgi_pack}.tar.gz ]
then
  wget http://projects.unbit.it/downloads/${uwsgi_pack}.tar.gz
fi
tar -xvzf ${uwsgi_pack}.tar.gz
cd ${uwsgi_pack}
make
cp uwsgi $WORK_ROOT/bin
cd ..

git clone https://github.com/gnosek/nginx-upstream-fair.git fair

if [ ! -e ${nginx_pack}.tar.gz ]
then
  wget http://nginx.org/download/${nginx_pack}.tar.gz
fi
tar -xvzf ${nginx_pack}.tar.gz

if [ ! -e ${pcre_pack}.tar.gz ]
then
  wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${pcre_pack}.tar.gz
fi
tar -xvzf ${pcre_pack}.tar.gz

#sudo apt-get install libxml2-dev

if [ ! -e $WORK_ROOT/distr/nginx ]
then
  mkdir $WORK_ROOT/distr/nginx
fi

#if [ ! -e $WORK_ROOT/distr/nginx/logs ]
#then
#  mkdir $WORK_ROOT/distr/nginx/logs
#fi

cd ${nginx_pack}
./configure --prefix=$WORK_ROOT/distr/nginx \
--conf-path=$WORK_ROOT/conf/nginx.conf \
--pid-path=../../pids/nginx.pid \
--error-log-path=../../logs/nginx.error.log \
--http-log-path=../../logs/nginx.access.log \
--with-pcre=../${pcre_pack}/ \
--with-http_ssl_module \
--add-module=../fair/ \
--user=$user \
--group=$group
make && make install
cp objs/nginx $WORK_ROOT/bin 
cp $WORK_ROOT/defaults/nginx.conf $WORK_ROOT/distr/nginx/conf/
cd ..
cp ${uwsgi_pack}/nginx/uwsgi_params $WORK_ROOT/distr/nginx/conf/

cd $pwd
