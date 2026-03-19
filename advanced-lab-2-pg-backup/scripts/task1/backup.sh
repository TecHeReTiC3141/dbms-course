#!/usr/bin/env bash

DATE=$(date +%Y-%m-%d-%H-%M-%S)

# Создание дампа
pg_dumpall -h localhost -p 9052 -U postgres1 | gzip -9 > ~/backups/dumps/pgdump-$DATE.sql.gz

# Перемещение на резервный хост
scp ~/backups/dumps/pgdump-$DATE.sql.gz postgres1@rshd-lab2-backup:~/backups/dumps

# Удаление локальной копии
rm ~/backups/dumps/pgdump-$DATE.sql.gz

# Очистка старых архивов на резервном хосте
ssh postgres1@rshd-lab2-backup "find ~/backups/dumps -name '*.sql.gz' -mtime +28 -delete"