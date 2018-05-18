ARG BASE
FROM ${BASE}

ARG VERSION_PYTHON=3.5
ARG IMAGE_NAME="uwsgi-python3"

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
        python3.5 \
        python3-dev \
        python3-pip \
        uwsgi-plugin-python3 \
#
    && update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.5 2 \
    && update-alternatives --list python \
    && python --version | grep -iE "python ${VERSION_PYTHON}" \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 \
    && update-alternatives --list pip \
    && pip install -U pip setuptools wheel \
#
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
