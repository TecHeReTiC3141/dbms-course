#!/usr/bin/env bash

# Остановка PostgreSQL
/usr/lib/postgresql/18/bin/pg_ctl -D $PGDATA stop

# Очистка каталога данных (ВАЖНО!)
rm -rf $PGDATA/*
tar -xvf $HOME/base_backup/base.tar.gz -C $PGDATA

cat >> $PGDATA/postgresql.conf <<EOF
restore_command = 'cp $HOME/wal_archive/%f %p'
recovery_target_time = '$SCHEMA_TIME'
EOF

# Создаем сигнальный файл для запуска в режиме восстановления
touch $PGDATA/recovery.signal

# Запуск восстановления
/usr/lib/postgresql/18/bin/pg_ctl -D $PGDATA -l $PGDATA/recovery.log start

# Мониторинг процесса
tail -f $PGDATA/recovery.log