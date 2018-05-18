#
# Настраиваем /etc/pgbouncer/pgbouncer.ini (если еще не создан)
# ... и определяем переменные


if [ ! -e /etc/pgbouncer ] ; then
    if echo "${SAVE_PGBOUNCER}" | grep -iE '^(1|true|y|yes|on|enabled?)$' ; then
        mkdir -pv /srv/pgbouncer
        ln -s /srv/pgbouncer /etc/pgbouncer
    else
        mkdir /etc/pgbouncer
    fi
fi

$( python2 ./pym/30-configure-pgbouncer.py \
    | tee -a /etc/profile.d/30-local-pgbouncer.sh )
