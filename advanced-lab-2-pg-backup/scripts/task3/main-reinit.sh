#!/usr/bin/env bash

export PGDATA=$HOME/xxz67                    
export PGWAL=$HOME/zql96                      
export PGENCODE=WIN1251                        
export PGLOCALE= C
export PGUSERNAME=postgres1                    
export PGPORT=9052                              
export PGHOST=pg186                              
export LANG=C
export LC_ALL= C
export PGLOG=$PGDATA/server.log 

# Создаем новый каталог для восстановления
NEW_DATA_DIR="${PGDATA}_recovery"
mkdir -p $NEW_DATA_DIR

# Инициализируем новую БД
/usr/lib/postgresql/18/bin/initdb -D "$NEW_DATA_DIR" --encoding=$PGENCODE --locale=$PGLOCALE --lc-messages=$PGLOCALE --lc-monetary=$PGLOCALE --lc-numeric=$PGLOCALE --lc-time=$PGLOCALE --no-locale --username=$PGUSERNAME
echo "listen_addresses = '*'" >> $NEW_DATA_DIR/postgresql.conf
echo "port = 9052" >> $NEW_DATA_DIR/postgresql.conf

# Запускаем PostgreSQL с новым каталогом
/usr/lib/postgresql/18/bin/pg_ctl -D $NEW_DATA_DIR -l $NEW_DATA_DIR/server.log start

# Восстанавливаем данные (с учетом новых путей табличных пространств)
psql -h localhost -p 9052 postgres -f /home/postgres1/restore/pgdump-*.sql
/usr/lib/postgresql/18/bin/pg_ctl -D $NEW_DATA_DIR stop

# Перемещаем данные
rm -rf $PGDATA
mv $NEW_DATA_DIR $PGDATA

# Запускаем с оригинальным путем
/usr/lib/postgresql/18/bin/pg_ctl -D $PGDATA -l $PGLOG start