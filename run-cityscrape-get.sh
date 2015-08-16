#!/bin/bash -e

CONFIGFILE="config/cityscrape-config.sh"

# Bootstrap the config into our bash env
. $CONFIGFILE

# Activate virtualenv
. $CITYSCRAPE_VIRTUALENV_DIR/bin/activate

echo "Running Cityscrape Download"

python $BASEDIR/src/grab_all_files.py