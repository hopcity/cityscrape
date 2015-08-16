#!/bin/bash -e

CONFIGFILE="config/cityscrape-config.sh"

. $CONFIGFILE

echo "Running Cityscrape PostgreSQL Ingest"
pushd $OUTPUT_DIR

echo "Unzipping files..."
unzip -f "*.zip"

if [ -z "$(ls *.shp)" ]
	then
		echo "No *.shp files found, exiting..."
		break
	else
		for f in *.shp
			do
				echo "Loading "$f

				ogr2ogr -overwrite -progress -skipfailures -f "PostgreSQL" PG:"host=localhost user=postgres dbname=city" $f#

			done
fi

for f in *.mdb

	do
		echo "Extracting tables from $f"

		mdb-schema $f postgres | sed 's/Char/Varchar/g' | sed 's/Postgres_Unknown 0x0c/text/g' | psql -h localhost -U postgres -d city

		tables=$(echo -en $(mdb-schema $f postgres | grep "CREATE TABLE" | awk '{ print $3 }' | sed -e 's/"//g');)

	for i in $tables

		do
			echo "[File: "$f" ]	[Table - "$i"]"

			mdb-export -D ‘%%Y-%%m-%%d %%H:%%M:%%S’ -I postgress -q \’ -R \; $f $i | psql -d city -U postgres -w -h localhost

	done

done

# # return to project root $BASEDIR
popd

