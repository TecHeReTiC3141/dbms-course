#!/bin/bash
# Переменные, которые передает Pgpool:
# %d = ID упавшей ноды, %H = Хост новой реплики, %m = ID новой реплики
failed_node_id=$1
new_master_host=$2
new_master_port=$3
new_master_node_id=$4

echo "Failover: Нода $failed_node_id упала. Продвигаем ноду $new_master_node_id ($new_master_host)"

# Используем psql для выполнения promote на новой мастер-ноде
PGPASSWORD=postgres psql -h $new_master_host -p $new_master_port -U postgres -d postgres -c "SELECT pg_promote(true, 60);"

if [ $? -eq 0 ]; then
    echo "Failover: Нода $new_master_host успешно продвижена до мастера."
    exit 0
else
    echo "Failover: НЕ УДАЛОСЬ продвинуть ноду $new_master_host!"
    exit 1
fi