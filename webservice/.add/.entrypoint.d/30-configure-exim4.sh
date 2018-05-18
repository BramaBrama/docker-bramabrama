#
# пописываем EHLO-параметр сервера
#

echo "${VIRTUAL_HOST%%,*}" > /etc/exim4/primary_host
