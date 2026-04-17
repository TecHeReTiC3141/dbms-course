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


mkdir -p $PGDATA
mkdir -p $PGWAL
                
/usr/lib/postgresql/18/bin/initdb -D "$PGDATA" --encoding=$PGENCODE --locale=$PGLOCALE --lc-messages=$PGLOCALE --lc-monetary=$PGLOCALE --lc-numeric=$PGLOCALE --lc-time=$PGLOCALE --no-locale --username=$PGUSERNAME

/usr/lib/postgresql/18/bin/pg_ctl -D $PGDATA -l $PGLOG start

# Set postgres1 password in db using ALTER USER postgres1 WITH PASSWORD '1234';

echo "listen_addresses = '*'" >> $PGDATA/postgresql.conf
echo "port = 9052" >> $PGDATA/postgresql.conf
cat > $PGDATA/pg_hba.conf << 'EOF'
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5
local   all             postgres1                               peer
local   all             all                                     reject
EOF


/usr/lib/postgresql/18/bin/pg_ctl -D $PGDATA restart