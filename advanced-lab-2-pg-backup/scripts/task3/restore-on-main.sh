#!/usr/bin/env bash

mkdir -p ~/restore2/test_recover ~/restore2/frj34

# Находим последний бэкап
latest_backup=$(ssh postgres1@rshd-lab2-backup "ls -t ~/backups/dumps/*.sql.gz | head -1")

# Копируем с резервного узла
scp postgres1@rshd-lab2-backup:$latest_backup ~/restore2

# Распаковка и замена путей
gzip -d ~/restore2/pgdump-*.sql.gz
sed -i 's|/home/postgres1/restore/test_recover|/home/postgres1/restore2/test_recover|g' ~/restore/pgdump-*.sql
sed -i 's|/home/postgres1/restore/frj34|/home/postgres1/restore2/frj34|g' ~/restore/pgdump-*.sql

# Создаем новые директории для табличных пространств

chown postgres:postgres /home/postgres1/test_recover 
chown postgres:postgres /home/postgres1/frj34 