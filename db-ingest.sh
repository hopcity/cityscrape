#!/bin/bash -e

# Something fucky with the postgres configuration
# vagrant@city-scrape:/vagrant$ sudo su
# root@city-scrape:/vagrant# su postgres
# postgres@city-scrape:/vagrant$

CONFIGFILE="config/cityscrape-config.sh"

. $CONFIGFILE

echo "Running Cityscrape PostgreSQL Ingest"
pushd $WORKDIR

for f in *.mdb

	do
		echo "Extracting tables from $f"

		mdb-schema $f postgres | sed 's/Char/Varchar/g' | sed 's/Postgres_Unknown 0x0c/text/g' | psql -U vagrant city -a -f

		tables=$(echo -en $(mdb-schema $f postgres | grep "CREATE TABLE" | awk '{ print $3 }' | sed -e 's/"//g');)

		for i in $tables

			do
				echo "[File: "$f" ]	[Table - "$i"]"

				mdb-export -D ‘%%Y-%%m-%%d %%H:%%M:%%S’ -I postgress -q \’ -R \; $f $i | psql -U vagrant city -w

			done

	done

# # return to project root $BASEDIR
popd

