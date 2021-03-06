# Описание проекта

Данный проект расширяет образ с `debian` до минимально-функционального вебсервера, способного работать как элемент микросервисной архитектуры


## Сервисы

- `nginx` - веб-сервис
- `pgbouncer` - сервис, проксирующий подключение к postgresql-серверу
- `cron`
- `proxy_memcached` - если инициализирована переменная `MEMCACHED_HOST` - на `127.0.0.1:11211` запускается проксирующий сервер до указанного memcached-сервера, а так же переопределяются переменные окружения `MEMCACHED_HOST` и `MEMCACHED_PORT`
- `proxy_redis` - если инициализирована переменная `REDIS_HOST` - на `127.0.0.1:6379` запускается проксирующий сервер до указанного memcached-сервера, а так же переопределяются переменные окружения `REDIS_HOST` и `REDIS_PORT`


# Описание переменных, управляющих поведением при запуске

## uid/gid пользователя (полезно при разработке)

Если требуется переопределить uid/gid пользователя (к примеру, чтоб согласовать права на монтируемые ресурсы), сделать это можно используя переменные
- `APP_UID`
- `APP_GID`

В случае, если хотя-бы одна из этих переменных определена, то соответсвующим образом изменяется `uid` или `gid` пользователя, а так же права на содержимое каталога `/srv`


## Переменные, управляющие запуском служб

Значение `true`/`false`

- `SUPERVISOR_autostart_nginx` - управляет автозапуском `nginx`
- `SUPERVISOR_autostart_pgbouncer` - управляет автозапуском `pgbouncer`
- `SUPERVISOR_autostart_exim4` - управляет автозапуском `exim`
- `SUPERVISOR_autostart_cron` - управляет автозапуском `cron`

## Дополнительная настройка служб

### Nginx

- `NGINX_VHOST_BASIC_USER` и `NGINX_VHOST_BASIC_PASS` - определяют в открытом виде логин/пароль для BasicAuth-записи
- `NGINX_VHOST_BASIC` - если требуется добавить тело .passwd-файла, сделать это можно тут


### PgBouncer / подключение к postgresql

Сервис позволяет сохранить реальные реквизиты подключения к postgresql-серверу в `/etc/pgbouncer/pgbouncer.ini` и после этого, через localhost, подключаться к этому серверу любым пользователем/паролем

Переменные для конфигурирования

- `SAVE_PGBOUNCER` - сохранять ли конфигурацию pgbouncer между перезагрузками в каталог `/srv/pgbouncer`
- `PSQL_HOST` `PSQL_PORT` `PSQL_USER` `PSQL_PASS` - реквизиты доступа к postgresql-серверу
  После настройки, эти данные прописываются в `/etc/pgbouncer/pgbouncer.ini`, и заменяются значениями подключения к localhost

- `PSQL_NAME` - имя БД (требуется не для pgbouncer, а для приложения)


### Cron

В этом образе не настроен. При необходимости, можно добавить необходимые конфигурационные файлы в один из `/etc/cron*/`-каталогов и включить автозапуск cron переменной `SUPERVISOR_autostart_cron`


### Proxy Memcached/Redis

Службы `Proxy Memcached` и `Proxy Redis` представляют собой реверс-прокси утилиту `tcppm` из набора утилит `3proxy`, позволяющую подключиться к удаленным серверам через `localhost`

Для указания удаленных серверов используются переменные cоостветсвенно

|сервис   |адрес удаленого сервиса | порт удаленного сервиса|
|:-------:|------------------------|------------------------|
|memcached| `MEMCACHED_HOST`       | `MEMCACHED_PORT` |
|redis    | `REDIS_HOST`           | `REDIS_PORT` |


### Exim4

Локальный почтовый сервер.
Настроен как open relay.
Нужен чтоб можно было отправлять почту с текущего домена.

# Точки монтирования

- `/docker-entrypoint.d` - каталог, из которого, наравне c вмороженным в образ каталогом `/.entrypoint.d`, в алфавитном порядке запускаются скрипты при выполнении штатного `ENTRYPOINT`
- `/srv/pgbouncer` каталог, в который сохраняются конфиги pgbouncer при переменной `SAVE_PGBOUNCER`=`true`
