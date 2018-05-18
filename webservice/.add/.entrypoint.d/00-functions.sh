#
# Инициализация функций
#

################################################################################
# служебные функции


in_array() {
    local i=$1 j
    shift
    for j; do
        [ "x$i" != "x$j" ] || return 0
    done
    return 1
}

is_ok() { return $(set +x ; awk -v v="$1" \
        'BEGIN{ print(!match(tolower(v), "^(y|yes|on|true|enabled?|1)$"))}'); }

is_no() { return $(set +x ; awk -v v="$1" \
        'BEGIN{ print(match(tolower(v), "^(y|no|off|false|disabled?|0)$"))}'); }
