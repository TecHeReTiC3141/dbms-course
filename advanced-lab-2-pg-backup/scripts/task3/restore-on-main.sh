#!/usr/bin/env bash

mkdir -p ~/restore/test_recover ~/restore/frj34

# Находим последний бэкап
latest_backup=$(ssh postgres1@rshd-lab2-backup "ls -t ~/backups/dumps/*.sql.gz | head -1")

# Копируем с резервного узла
scp postgres1@rshd-lab2-backup:$latest_backup ~/restore

# Распаковка и замена путей
gzip -d ~/restore/pgdump-*.sql.gz
sed -i 's|/home/postgres1/test_recover|/home/postgres1/restore/test_recover|g' ~/restore/pgdump-*.sql
sed -i 's|/home/postgres1/frj34|/home/postgres1/restore/frj34|g' ~/restore/pgdump-*.sql

# Создаем новые директории для табличных пространств

chown postgres:postgres /home/postgres1/restore/test_recover 
chown postgres:postgres /home/postgres1/restore/frj34 