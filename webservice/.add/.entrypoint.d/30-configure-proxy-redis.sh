#
# добавляем демона, проксирующего запросы к redis-серверу, если требуется
#


if [ -n "${REDIS_HOST}" ]; then
    cat > /etc/supervisor/conf.d/proxy_redis.conf << EOF
[program:proxy-memcache]
command = tcppm -i127.0.0.1 6379 ${REDIS_HOST} ${REDIS_PORT:-6379}

# autostart = %(ENV_SUPERVISOR_autostart_proxy_redis)s
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

    $( (cat | tee /etc/profile.d/30-local-proxy-redis.sh) << EOF
export REDIS_HOST=127.0.0.1
export REDIS_PORT=6379
export SUPERVISOR_autostart_proxy_redis=true
EOF
)

fi
