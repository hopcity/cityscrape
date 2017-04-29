#!/bin/bash
CONFIGFILE="config/cityscrape-config.sh"

. $CONFIGFILE

pushd $WORKDIR
while read line; do
    $line
done < "$SHAPEFILE_MANIFEST"
popd