#!/usr/bin/env bash

# Настройка архивации WAL
psql -h localhost -p 9052 postgres <<EOF
ALTER SYSTEM SET wal_level = 'replica';
ALTER SYSTEM SET archive_mode = on;
ALTER SYSTEM SET archive_command = 'test ! -f /var/lib/postgresql/wal_archive/%f && cp %p /var/lib/postgresql/wal_archive/%f';
EOF

# Создаём каталог для WAL-архивов
mkdir -p ~/wal_archive

# Проверяем, что настройки применились
/usr/lib/postgresql/18/bin/pg_ctl -D $PGDATA restart
psql -h localhost -p 9052 postgres -c "SHOW archive_mode; SHOW archive_command;"

# Создание базового бэкапа перед изменениями
cat >> $PGDATA/pg_hba.conf << EOF
host    replication  postgres1  ::1/128       trust
host    replication  postgres1  127.0.0.1/32  trust
host    replication  postgres  ::1/128       trust
host    replication  postgres  127.0.0.1/32  trust
EOF
/usr/lib/postgresql/18/bin/pg_ctl -D $PGDATA restart
/usr/lib/postgresql/18/bin/pg_basebackup -D $HOME/base_backup -h localhost -p 9052 -U postgres1 -P -Ft -Xs -z