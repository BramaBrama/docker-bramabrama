ARG BASE
FROM ${BASE}

ARG VERSION_PYTHON=2.7
ARG IMAGE_NAME="uwsgi-python2"

LABEL \
    org.label-schema.name="${IMAGE_NAME}" \
    org.label-schema.docker.cmd="docker run -d -p 80:80 ${IMAGE_NAME}" \
    org.label-schema.docker.cmd.devel="docker run -d -p 80:80 -p 8005:8005 -e APP_UID=$$(id -u) -e APP_GID=$$(id -g) -e SUPERVISOR_autostart_runserver=1 -v ./my-own-entrypoint.d/:/docker-entrypoint.d/:ro ${IMAGE_NAME}"

ENV \
    SUPERVISOR_autostart_uwsgi=true \
    SUPERVISOR_autostart_runserver=false

ADD .add/ /

RUN set -e -x \
# убеждаемся в корректности аргумента
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        uwsgi \
        python2.7 \
        python-dev \
        python-pip \
        uwsgi-plugin-python \
    && pip install -U pip setuptools wheel \
#
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
