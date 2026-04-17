#!/bin/bash
# Переменные: %d = ID старой мастер-ноды, %H = адрес новой мастер-ноды
old_master_id=$1
new_master_host=$2
old_master_host=$3
old_master_port=$4
old_master_data_dir=$5

echo "Follow Primary: Перестраиваем старую мастер-ноду $old_master_host как реплику для $new_master_host"

# 1. Очищаем data directory внутри контейнера
# ВАЖНО: Подумайте о безопасности! Лучше выполнять через docker exec.
# Упрощенный пример:
docker exec primary bash -c "rm -rf /var/lib/postgresql/data/*"

# 2. Выполняем pg_basebackup с новой мастер-ноды
PGPASSWORD=replicator_password docker exec primary bash -c "pg_basebackup -h $new_master_host -U replicator -D /var/lib/postgresql/data -X stream -P"

# 3. Создаем standby.signal для перевода в режим реплики
docker exec primary bash -c "touch /var/lib/postgresql/data/standby.signal"

echo "Follow Primary: Восстановление старого мастера завершено."
exit 0
