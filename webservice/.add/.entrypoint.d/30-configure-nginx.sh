################################################################################
# nginx configuration section

_auth_conf="${NGINX_VHOST_CONFIG_DIR}/20-auth.conf"

if [ -z "${NGINX_VHOST_CONFIG_DIR}" ]; then
    echo "Something strange happened with environment NGINX_VHOST_CONFIG_DIR" >&2
    :
elif [ -e "${_auth_conf}" ]; then
    echo "Exist ${_auth_conf}" >&2
    ls -ld "${_auth_conf}" >&2
else
    _passwd_file="${NGINX_VHOST_CONFIG_DIR}/.app.htpasswd"
    _is_basic=false
    # если определено тело списка VHOST_BASIC, помещаем его в соответсвующий файл
    if [ -n "${NGINX_VHOST_BASIC:+x}" ]; then
        _is_basic=true
        echo "${NGINX_VHOST_BASIC}" >> "${_passwd_file}"
    fi

    # если определены переменные VHOST_BASIC_USER и VHOST_BASIC_PASS ...
    if [ -n "${NGINX_VHOST_BASIC_USER:+x}" -a -n "${NGINX_VHOST_BASIC_PASS:+x}" ]; then
        _is_basic=true
        cat >> "${_passwd_file}" << EOF
${VHOST_BASIC_USER}:$(echo -n "${NGINX_VHOST_BASIC_PASS}" | openssl passwd -stdin)
EOF
    fi

    if ${_is_basic} ; then
        cat >> "${_auth_conf}" << EOF
auth_basic "Restricted ${VIRTUAL_HOST}";
auth_basic_user_file ${_passwd_file};
EOF
    else
        : >> "${_auth_conf}"
    fi
fi

unset _auth_conf _is_basic _passwd_file
