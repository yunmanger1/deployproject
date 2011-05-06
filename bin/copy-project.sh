#!/bin/bash

pwd=$( readlink -f "$( dirname "$BASH_SOURCE" )" )
if [ ! $WORK_ROOT ]
then
  echo "init"
  source $pwd/startwork
fi

proj=$1

if [ ! $1 ]
then
  echo "specify project"
  exit 1
fi

cd $WORK_ROOT
DEPLOY_DIR=$WORK_ROOT/ondeploy
PROJECTS_DIR=$WORK_ROOT/projects 

PROJD_DIR=$DEPLOY_DIR/$proj
PROJS_DIR=$PROJECTS_DIR/$proj

if [ ! -e $PROJS_DIR ]
then
  exit 2
fi


if [ ! -e $PROJD_DIR ]
then
  mkdir $PROJD_DIR
fi

cd $PROJS_DIR
find . | grep -v '/\.' | grep -v '.pyc$' | cpio -dump --verbose $PROJD_DIR