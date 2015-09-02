#!/bin/bash

CONFIGFILE="config/cityscrape-config.sh"

. $CONFIGFILE

pushd $WORKDIR
mdb_files=$(echo `ls *.mdb 2>/dev/null`)
if [ -z "$mdb_files" ]; then
    echo "No *.mdb files found, exiting..."
else
  for mdb_file in $mdb_files
    do
      echo "Extracting tables from $mdb_file"
      ddl_file=$mdb_file$DDL_FILE_SUFFIX

      mdb-schema $mdb_file | sed 's/Char/Varchar/g' | sed 's/Postgres_Unknown 0x0c/text/g' > ddl/$ddl_file

      tables=$(echo -en $(mdb-schema $mdb_file postgres | grep "CREATE TABLE IF NOT EXISTS" | awk '{ print $3 }' | sed -e 's/"//g');)

      if [ -z "$tables" ]
        then
          echo "No tables found, skipping table ddl generation."
        else
          for table in $tables
            do
              echo $table > "$table$DDL_FILE_SUFFIX"
            done
      fi
    done
fi
popd