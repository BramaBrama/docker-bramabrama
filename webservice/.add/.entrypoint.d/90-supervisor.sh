#
# настраиваем переменные, управляющие автозапуском служб supervisor
#

for _cfg in /etc/supervisor/conf.d/*.conf ; do
    _srv_name=$(basename "$_cfg" .conf)
    env_name="SUPERVISOR_autostart_${_srv_name}"
    eval _val="\$${env_name}"
    if is_ok "$_val" ; then
        value=true
    else
        value=false
    fi
    export "${env_name}=${value}"
done

unset _cfg _srv_name env_name _val value
