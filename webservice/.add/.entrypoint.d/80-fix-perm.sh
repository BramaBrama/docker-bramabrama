#
# исправляем права на каталог /srv, если это требуется
#

if is_ok "${__fix_perm}" ; then
    chown -Rc "${APP_UID}:${APP_GID}" /srv/
fi
