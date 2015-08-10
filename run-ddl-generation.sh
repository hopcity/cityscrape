#!/bin/bash

CONFIGFILE="config/cityscrape-config.sh"

. $CONFIGFILE

echo "Running Cityscrape PostgreSQL Ingest"

pushd $WORKDIR
echo "Unzipping files..."

zip_files=$(echo `ls *.zip 2>/dev/null`)
if [ -z "$zip_files" ]; then
  echo "No *.zip files found, skipping unzip..."
else
  for zip_file in $zip_files;
    do
      unzip -o $zip_file
  done
  echo "Unzip complete"
fi

shp_files=$(echo `ls *.shp 2>/dev/null`)
if [ -z "$shp_files" ]; then
  echo "No *.shp files found, skipping ogr2ogr..."
else
  for shp_file in $shp_files;
    do
      echo `ls $shp_file`
      # ogr2ogr -overwrite -progress -skipfailures -f "PostgreSQL" PG:"host=localhost user=postgres dbname=city" $shp_file
    done
fi

pushd $DDL_FILES
echo "Building ddl sql files now..."

mdb_files=$(echo `ls *.mdb 2>/dev/null`)
if [ -z "$mdb_files" ]; then
    echo "No *.mdb files found, exiting..."
else
  for mdb_file in $mdb_files
    do
      echo "Extracting tables from $mdb_file"
      ddl_file=$mdb_file$DDL_FILE_SUFFIX

      mdb-schema $mdb_file | sed 's/Char/Varchar/g' | sed 's/Postgres_Unknown 0x0c/text/g' > "$ddl_file"

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

