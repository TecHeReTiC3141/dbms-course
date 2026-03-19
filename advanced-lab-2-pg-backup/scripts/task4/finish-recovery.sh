#!/usr/bin/env bash

# Подтверждаем завершение восстановления
psql -h localhost -p 9052 postgres -c "SELECT pg_wal_replay_resume();"

# Удаляем сигнальный файл
rm $PGDATA/recovery.signal

# Убираем параметры восстановления
sed -i '/^restore_command/d' $PGDATA/postgresql.conf
sed -i '/^recovery_target_time/d' $PGDATA/postgresql.conf

# Перезапускаем сервер
/usr/lib/postgresql/18/bin/pg_ctl -D $PGDATA restart

# Проверить целостность данных (предварительно переиндексировав  индексы, связанные с table1 и table2)
psql -h localhost -p 9052 -U postgres1 -d wetgreenlaw -t -c "REINDEX INDEX idx_table1_name; REINDEX INDEX idx_table2_name; SELECT count(*) FROM table1; SELECT count(*) FROM table2;"