#!/bin/bash

CONFIGFILE="config/cityscrape-config.sh"

. $CONFIGFILE

echo "Running Cityscrape PostgreSQL Ingest"

pushd $WORKDIR
echo "Unzipping files..."

echo `ls *.zip` | xargs -n 1 unzip -o
popd