CONFIGFILE="config/cityscrape-config.sh"

. $CONFIGFILE

pushd $DDL_FILES

mdb_files=$(echo `ls *.mdb 2>/dev/null`)

# Create SQL files out of mdb files
if [[ -z "$mdb_files" ]]; then
  echo "No MDB Schema Definitions Found, Exiting..."
  exit 3
else
  for mdb in $mdb_files
    do
      cat $mdb | tr -d "[]" > $mdb.sql
    done
fi

# Pass SQL files to psql and execute against db
sql_files=$(echo `ls *postgres.sql 2>/dev/null`)
if [[ -z "$sql_files" ]]; then
  echo "No Postgres Schema DDL, Exiting..."
  exit 3
else
  for sql in $sql_files
    do
      psql -U vagrant -d city -a -w -f $sql
      echo "[File: $sql] Completed Succesfully"
    done
fi

popd