# -*- coding: utf-8 -*-

from __future__ import unicode_literals
import sys
if sys.version_info[0] < 3:
    reload(sys)
    sys.setdefaultencoding('utf-8')

from os import environ
from os.path import isfile
from ConfigParser import ConfigParser


###############################################################################
# определение переменных

EXAMPLE_FILE = '/etc/pgbouncer.example/pgbouncer.ini'
PGBOUNCER_FILE = '/etc/pgbouncer/pgbouncer.ini'

# DB_BACKEND = environ.get('DB_BACKEND', 'django.db.backends.sqlite3')
PSQL_HOST = (environ.get('PSQL_HOST') or 'postgres')
PSQL_PORT = (environ.get('PSQL_PORT') or '5432')
PSQL_USER = (environ.get('PSQL_USER') or 'postgres')
PSQL_PASS = environ.get('PSQL_PASS', '')
PSQL_NAME = (environ.get('PSQL_NAME') or environ.get('VIRTUAl_HOST'))


###############################################################################
# настройка pgbouncer.ini

if not isfile(PGBOUNCER_FILE):

    conf = ConfigParser()
    conf.read(EXAMPLE_FILE)

    conf.set(
        'databases', '*', 'host={h} port={p} user={u} password={pas}'.format(
            h=PSQL_HOST, p=PSQL_PORT, u=PSQL_USER, pas=PSQL_PASS))

    conf.set('pgbouncer', 'auth_type', 'any')
    conf.set('pgbouncer', 'auth_file', '')
    conf.set('pgbouncer', 'max_client_conn', '4096')
    conf.set('pgbouncer', 'server_check_query', 'SELECT 1')
    conf.set('pgbouncer', 'pool_mode', 'transaction')
    conf.set('pgbouncer', 'ignore_startup_parameters', 'extra_float_digits')
    conf.set('pgbouncer', 'dns_zone_check_period', '15')
    conf.set('pgbouncer', 'dns_nxdomain_ttl', '3')
    conf.set('pgbouncer', 'logfile', '')
    conf.set('pgbouncer', 'listen_port', '5432')
    conf.set('pgbouncer', 'listen_addr', '127.0.0.1')

    with open(PGBOUNCER_FILE, 'w') as pgb_file:
        conf.write(pgb_file)


###############################################################################
# в stdout пишем переинициализацию переменных

_new_env = (
    'PSQL_HOST=127.0.0.1',
    'PSQL_PORT=5432',
    'PSQL_USER={0}'.format(PSQL_USER),
    'PSQL_NAME={0}'.format(PSQL_NAME),
    'PSQL_PASS=secret',
)

sys.stdout.write('\n')

for _e in _new_env:
    sys.stdout.write('export {0}\n'.format(_e))
    sys.stderr.write('# {0}\n'.format(_e))
