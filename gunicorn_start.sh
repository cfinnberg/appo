#!/bin/bash

BASEDIR=$(dirname $(realpath $BASH_SOURCE))
APPNAME=$(basename $BASEDIR)		# APPNAME = Parent folder's name
USER=$(stat -c %U $BASEDIR)		# USER = Parent's folder owner
GROUP=$USER
WORKERS=3
BIND=unix:$BASEDIR/run/gunicorn.sock
DJANGO_SETTINGS_MODULE=$APPNAME.settings
DJANGO_WSGI_MODULE=$APPNAME.wsgi
LOG_LEVEL=error

cd $BASEDIR/$APPNAME
source $BASEDIR/venv/bin/activate

export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$BASEDIR/:$PYTHONPATH

exec $BASEDIR/venv/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $APPNAME \
  --workers $WORKERS \
  --user=$USER \
  --group=$GROUP \
  --bind=$BIND \
  --log-level=$LOG_LEVEL \
  --log-file=-
