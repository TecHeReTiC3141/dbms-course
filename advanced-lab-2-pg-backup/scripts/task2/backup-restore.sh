#!/usr/bin/env bash

latest_backup=$(ls -t ~/backups/dumps/*.sql.gz | head -1)
unpacked_file="${latest_backup%.gz}"

gzip -d $latest_backup
# sed -i '' 's|/var/db/postgres1/idd21|/var/db/postgres2/idd21|g' $unpacked_file
# sed -i '' 's|/var/db/postgres1/gzp28|/var/db/postgres2/gzp28|g' $unpacked_file
psql -h localhost -p 9052 -U postgres1 -d postgres -f $unpacked_file