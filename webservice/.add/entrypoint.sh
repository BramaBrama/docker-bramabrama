#!/bin/bash

set -e -x

for f in \
    $(find /.entrypoint.d/ /docker-entrypoint.d/ \
            -mindepth 1 -maxdepth 1 \
            -name '*.sh' -type f \
        | sed -nre 's:^/([^/]+)/([^/]+)$:\2/\1//\1/\2:p' \
        | sort -h \
        | sed -re 's:^.*//:/:' ) ; do
        # ^^^^^^^^^^^^^^^^^^^^^^- получаем список файлов из двух каталогов, 
        #                         ... упорядоченный по имени файла
    pushd "${f%/*}"
    . ./"${f##*/}"
    popd
done

exec "$@"
