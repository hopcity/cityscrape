#!/bin/bash

CONFIGFILE="config/cityscrape-config.sh"

. $CONFIGFILE

pushd $WORKDIR

if ! [[ -z $SHAPEFILE_MANIFEST ]]; then
  rm $SHAPEFILE_MANIFEST
else
  echo "Removeing old shapefile manifest"
  rm $SHAPEFILE_MANIFEST
fi

shp_files=$(echo `ls *.shp 2>/dev/null`)

if [ -z "$shp_files" ]; then
  echo "No *.shp files found, skipping ogr2ogr..."
else
  for shp_file in $shp_files;
    do
      echo ogr2ogr -overwrite -progress -skipfailures -f "PostgreSQL" PG:"host=localhost user=postgres dbname=city" $shp_file >> $SHAPEFILE_MANIFEST
    done
fi

popd