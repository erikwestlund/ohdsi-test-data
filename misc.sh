
# Quickly generate CSVs of every table in the SQLite Eunomia database.
mkdir -p data/eunomia/raw
TABLES=$(sqlite3 cdm.sqlite .tables)

for table in `echo $TABLES`; do
  sqlite3 -header -csv cdm.sqlite "select * from $table;" > data/eunomia/raw/$table.csv
done