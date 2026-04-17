psql -h localhost -p 9052 -U postgres1 -d wetgreenlaw -c "
INSERT INTO table1 (name) SELECT 'До сбоя ' || g FROM generate_series(101, 103) g;
INSERT INTO table2 (value) SELECT g * 10 FROM generate_series(101, 103) g;
INSERT INTO table3 (info) SELECT 'До сбоя ' || g FROM generate_series(101, 103) g;
"

SCHEMA_TIME=$(psql -h localhost -p 9052 -U postgres1 -d wetgreenlaw -t -c "SELECT now();")
echo "Цель восстановления: $SCHEMA_TIME"

psql -h localhost -p 9052 -U postgres1 -d wetgreenlaw -c "DROP TABLE table1; DROP TABLE table2"