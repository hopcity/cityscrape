#!/bin/bash -e

CONFIGFILE="config/cityscrape-config.sh"

. $CONFIGFILE

# echo "Step 1: Fetching Cityscrape data"
# ./get.sh

# echo "Step 2: Unzipping archives"
# ./unzip.sh

# echo "Step 3: Generating DDL files"
# ./generate-ddl.sh

# echo "Step 4: Generatign Shapefile load commands"
# ./generate-shapefile-manifest.sh

echo "Step 5: Generating Schema from ddl definitions"
./generate-schema-from-ddl.sh

# echo "Step 6: Upload Shapefiles to database"
# ./upload-shapefiles-from-manifest.sh