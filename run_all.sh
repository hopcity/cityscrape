#!/bin/bash -e

#	Dowload city access databases and shapes
./GrabAllFiles.py

#	Unzip Files
cd zipFiles
unzip -f "*.zip"


for f in *.shp
do
	echo "Loading "$f
	ogr2ogr -overwrite -progress -skipfailures -f "PostgreSQL" PG:"host=localhost user=postgres dbname=city" $f#
done


for f in *.mdb
do
	echo "Extracting tables from $f"

	mdb-schema $f postgres | sed 's/Char/Varchar/g' | sed 's/Postgres_Unknown 0x0c/text/g' | psql -h localhost -U postgres -d city #> /dev/null 2>&1

	tables=$(echo -en $(mdb-schema $f postgres | grep "CREATE TABLE" | awk '{ print $3 }' | sed -e 's/"//g');)
	for i in $tables
	do
		echo "[File: "$f" ]	[Table - "$i"]"
		mdb-export -D ‘%%Y-%%m-%%d %%H:%%M:%%S’ -I postgress -q \’ -R \; $f $i | psql -d city -U postgres -w -h localhost

	done

done



