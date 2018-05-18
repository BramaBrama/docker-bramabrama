FROM debian:9-slim

LABEL maintainer="mavriq <mb@bramabrama.com>"

################################################################################
# добавляем красивостей
ENV TERM="xterm" \
    LANG="en_US.UTF-8" \
    LESS="-R -M -i --shift=1" \
    LESSCOLOR="always" \
    force_color_prompt="yes" \
    DEBIAN_FRONTEND="noninteractive" \
# определяем переменные, необходимые для нормальной работы котнейнера
    APP_UID="" \
    APP_GID="" \
    APP_GROUP="app" \
    APP_USER="app" \
    NGINX_VHOST_CONFIG_DIR="/etc/nginx/vhosts-resources/default" \
    NGINX_VHOST_BASIC="" \
    NGINX_VHOST_BASIC_USER="" \
    NGINX_VHOST_BASIC_PASS="" \
    SUPERVISOR_autostart_nginx="true" \
    SUPERVISOR_autostart_pgbouncer="false" \
    SUPERVISOR_autostart_exim4="false" \
    SUPERVISOR_autostart_cron="false" \
    PSQL_HOST="" \
    PSQL_PORT="" \
    PSQL_USER="" \
    PSQL_PASS="" \
    PSQL_NAME="" \
    MEMCACHED_HOST="" \
    MEMCACHED_PORT="" \
    REDIS_HOST="" \
    REDIS_PORT="" \
    SAVE_PGBOUNCER="false"

# настраиваем метки
ARG BUILD_DATE=""
ARG VCS_REF="unknown"
ARG VCS_URL=""
ARG IMAGE_VERSION=""
ARG IMAGE_NAME="webservice"

LABEL \
    org.label-schema.schema-version="1.0" \
    org.label-schema.name="${IMAGE_NAME}" \
    org.label-schema.license="MIT" \
    org.label-schema.vendor="LTD InternetPartner" \
    org.label-schema.url="https://BramaBrama.com" \
    org.label-schema.description="WebService with Nginx as frontend, pgbouncer as proxy to postgres, exim4 as local open relay and local reverse proxies to memcache and redis" \
    # org.label-schema.usage="https://..." \
    org.label-schema.vcs-ref="${VCS_REF}" \
    org.label-schema.vcs-url="${VCS_URL}" \
    org.label-schema.docker.cmd="docker run -d -p 80:80 ${IMAGE_NAME}" \
    org.label-schema.docker.cmd.devel="docker run -d -p 80:80 -e APP_UID=$$(id -u) -e APP_GID=$$(id -g) -v ./my-own-entrypoint.d/:/docker-entrypoint.d/:ro ${IMAGE_NAME}" \
    # org.label-schema.docker.params="APP_UID, APP_GID, " \
    org.label-schema.version="${IMAGE_VERSION}" \
    org.label-schema.build-date="${BUILD_DATE}"

# указываем версии устанавливаемого ПО
ARG VERSION_PG="9.6"
ARG VERSION_NGINX="1.10*"
ARG VERSION_3PROXY="0.8.11"
ARG SHA1_3PROXY="d97537c0e2149a250640f9c3341502d3853c2da8"
ARG APT_GET="apt-get -y -q --no-install-recommends"

################################################################################
# устанавливаем базовые пакеты и минимально настраиваем юзабилити
RUN set -x \
# добавляем локали
    && echo 'en_US.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8' | tee /etc/locale.gen \
#
    && $APT_GET update \
    && $APT_GET install readline-common \
# это нам понадобится чтоб подключить репу postgres
    && $APT_GET install \
        apt-transport-https \
        ca-certificates \
        gnupg2 \
        wget \
# включаем прокрутку history по PageUp/PageDown
    && sed -re 's/# (.*history-search-(backward|forward))/\1/' -i /etc/inputrc \
#### устанавливаем дополнительные репозитории ####
    && . /etc/os-release \
# если базовый образ - ubuntu, то RELEASE определится тут
    && if [ -n "${VERSION_CODENAME+x}" ]; then \
        RELEASE="${VERSION_CODENAME}" ; \
# ... если debian - тут
    else \
        RELEASE=$(sed -nre 's;VERSION=.*\(([a-z]+)\).*;\1;p' < /etc/os-release) ; \
    fi \
# подключаем правильную репу postgres
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ ${RELEASE}-pgdg main" \
        | tee /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc \
        | apt-key add - \
# подключаем правильную репу nginx
    && echo "deb http://nginx.org/packages/${ID}/ ${RELEASE} nginx" \
        | tee /etc/apt/sources.list.d/nginx.list \
    && wget --quiet -O- https://nginx.org/keys/nginx_signing.key \
        | apt-key add - \
# обновляем список доступных пакетов с учетом новых реп и обновляем систему
    && $APT_GET update \
    && $APT_GET upgrade \
#
# устанавливаем ряд утилит, нужных как для работы, так и для отладки
    && $APT_GET install \
        acl \
        apt-utils \
        arping \
        bash-completion \
        binutils \
        busybox \
        bzip2 \
        cron \
        curl \
        dnsutils \
        exim4 \
        file \
        iproute2 \
        iputils-ping \
        less \
        locales \
        lsof \
        mailutils \
        mc \
        mtr \
        python \
        rsync \
        socat \
        strace \
        'supervisor=3.3*' \
        tcpdump \
        telnet \
        traceroute \
        tzdata \
        vim \
        wget \
        whois \
        xz-utils \
# installing postgres and pgbouncer
        pgbouncer \
        "postgresql-client${VERSION_PG:+-${VERSION_PG}}" \
# installing nginx
        nginx="${VERSION_NGINX}" \
        nginx-common="${VERSION_NGINX}" \
#
    && sed -re 's/^((logfile|childlogdir).*)$/;; \1/' -i \
        /etc/supervisor/supervisord.conf \
#
    && mv /etc/pgbouncer /etc/pgbouncer.example \
#
    && ln -svf /dev/stdout /var/log/nginx/access.log \
    && ln -svf /dev/stderr /var/log/nginx/error.log \
    #
    && $APT_GET install \
        build-essential \
        checkinstall \
        libevent-dev \
    && wget -O /tmp/3proxy.tar.gz \
        https://github.com/z3APA3A/3proxy/archive/${VERSION_3PROXY}.tar.gz \
    && echo "${SHA1_3PROXY} /tmp/3proxy.tar.gz" | sha1sum -c \
    && tar xvzpf /tmp/3proxy.tar.gz  -C /tmp/ \
    && cd /tmp/3proxy-${VERSION_3PROXY} \
    && echo '#define ANONYMOUS 1' >> src/proxy.h \
    && make -f Makefile.Linux \
    && checkinstall -y make -f Makefile.Linux install \
    && cd - \
    && rm -rf /tmp/3proxy-${VER_3PROXY} /tmp/3proxy.tar.gz \
#
    && groupadd -r "${APP_GROUP}" \
    && useradd -r -s /bin/false -m -d /srv/home -g "${APP_GROUP}" "${APP_USER}" \
    && usermod -aG "${APP_GROUP}" www-data \
#
    && $APT_GET purge \
        apt-transport-https \
        build-essential \
        checkinstall \
        libevent-dev \
#
    && $APT_GET autoremove \
    && $APT_GET clean \
    && rm -rf /var/lib/apt/lists/*

################################################################################
ADD .add/ /
VOLUME ["/docker-entrypoint.d"]
ENTRYPOINT ["/entrypoint.sh", "/srv/pgbouncer"]
CMD ["supervisord", "-n"]
EXPOSE 80
