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

uwsgi_pack=uwsgi-0.9.7.2
nginx_pack=nginx-0.7.65
pcre_pack=pcre-8.12
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

cd ${nginx_pack}
./configure --prefix=$WORK_ROOT/distr/nginx \
--add-module=../${uwsgi_pack}/nginx/ \
--with-pcre=../${pcre_pack}/ \
--user=$user \
--group=$group
make && make install
cp objs/nginx $WORK_ROOT/bin 
cp $WORK_ROOT/defaults/nginx.conf $WORK_ROOT/distr/nginx/conf/
cd ..
cp ${uwsgi_pack}/nginx/uwsgi_params $WORK_ROOT/distr/nginx/conf/

cd $pwd