################################################################################
# environment initialization

_uid=$(getent passwd app | cut -d: -f3)
_gid=$(getent group app | cut -d: -f3)

: ${APP_UID:=${_uid}}
: ${APP_GID:=${_gid}}

__fix_perm=

if [ "x${APP_GID}" != "x${_gid}" ] ; then
    groupmod -o -g "${APP_GID}" "${APP_GROUP}"
    __fix_perm=true
fi

if [ "x${APP_UID}" != "x${_uid}" ] ; then
    usermod -o -u "${APP_UID}" "${APP_USER}"
    __fix_perm=true
fi

unset _uid _gid
export APP_UID APP_GID
cat > /etc/profile.d/10-local-fix-uid-gid-of-app.sh << EOF

export APP_UID=$APP_UID
export APP_GID=$APP_GID

EOF
