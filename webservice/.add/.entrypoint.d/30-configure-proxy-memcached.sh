#
# добавляем демона, проксирующего запросы к memcache-серверу, если требуется
#


if [ -n "${MEMCACHED_HOST}" ]; then
    cat > /etc/supervisor/conf.d/proxy_memcached.conf << EOF
[program:proxy-memcache]
command = tcppm -i127.0.0.1 11211 ${MEMCACHED_HOST} ${MEMCACHED_PORT:-11211}

# autostart = %(ENV_SUPERVISOR_autostart_proxy_memcached)s
autostart = true
autorestart = true

stopasgroup = true
killasgroup = true

stdout_logfile = /dev/stdout
stderr_logfile = /dev/stderr
stdout_logfile_maxbytes = 0
stderr_logfile_maxbytes = 0

user = nobody
EOF

    $( (cat | tee /etc/profile.d/30-local-proxy-memcached.sh) << EOF
export MEMCACHED_HOST=127.0.0.1
export MEMCACHED_PORT=11211
export SUPERVISOR_autostart_proxy_memcached=true
EOF
)

fi
