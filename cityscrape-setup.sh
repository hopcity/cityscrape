#!/bin/bash -e

echo "Setting up Cityscrape"

CONFIGFILE="config/cityscrape-config"
. $CONFIGFILE

mkdir zipFiles

# Need to install virtualenv first
pip install virtualenv==1.10.1


if [ -d "$CITYSCRAPE_VIRTUALENV_DIR"]
then
  echo "Virtualenv $CITYSCRAPE_VIRTUALENV_DIR exists, skipping creation!"
else
  virtualenv $CITYSCRAPE_VIRTUALENV_DIR
fi

# Activate the virtualenv
. $CITYSCRAPE_VIRTUALENV_DIR/bin/activate

# WARNING: this requires that pg_config be in the path and that Postgres be installed

pip install beautifulsoup4==4.4.0
pip install requests==2.7.0
pip install wget==2.2

echo "Cityscrape setup complete!"