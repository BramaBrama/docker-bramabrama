#!/bin/bash

set -x -e
cd /srv/app

for s in /etc/local.script/.app.pre.d/*.sh ; do
    [ -f "$s" ] || continue
    printf "\n%80s\n" "" | tr \  \#
    source "$s"
done

exec /usr/bin/pyhton2 ./manage.py runserver 0.0.0.0:8005
