#!/bin/bash

CONFIGFILE="config/cityscrape-config.sh"

. $CONFIGFILE

pushd $DDL_FILES

sql=$(echo `ls *b.sql 2>/dev/null`)

if [[ -z "$sql" ]]; then
  echo "No DDL files found for marshalling, exiting..."
  exit 3
else
  echo $sql | xargs -0 python ../../src/marshall.py
fi