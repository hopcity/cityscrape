#!/bin/bash -e

if [[ -z "$1" ]] ; then
	echo "Cityscape requires at least 1 argument - the database to be used for the ingest (currently \"postgresql\")"
	exit 3
fi

CONFIGFILE="config/cityscrape-config.sh"

# Bootstrap the config into our bash env
. $CONFIGFILE

# Activate virtualenv
. $CITYSCRAPE_VIRTUALENV_DIR/bin/activate

echo "Running Cityscrape"

python $BASEDIR/src/grab_all_files.py

#	Push path to stack (as opposed to cd) and unzip files
pushd $STL_CITY_DOWNLOAD_DIR

unzip -f "*.zip"

for f in *.shp
do
	echo "Loading "$f
	ogr2ogr -overwrite -progress -skipfailures -f "PostgreSQL" PG:"host=localhost user=postgres dbname=city" $f#
done


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

# return to project root $BASEDIR
popd

