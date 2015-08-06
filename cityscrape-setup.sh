#!/bin/bash -e

echo "Setting up Cityscrape"

CONFIGFILE="config/cityscrape-config.sh"
. $CONFIGFILE

# Create working directories for ingest
if [ -d "$STL_CITY_DOWNLOAD_DIR" ]
then
  echo "$STL_CITY_DOWNLOAD_DIR already exists"
else
  mkdir $STL_CITY_DOWNLOAD_DIR
fi

# Need to install virtualenv first
pip install virtualenv==1.10.1

# Set up virtualenv if not exists
if [ -d "$CITYSCRAPE_VIRTUALENV_DIR" ]
then
  echo "Virtualenv $CITYSCRAPE_VIRTUALENV_DIR exists, skipping creation!"
else
  virtualenv $CITYSCRAPE_VIRTUALENV_DIR
fi

# Activate the virtualenv
. $CITYSCRAPE_VIRTUALENV_DIR/bin/activate

# Install Python libraries
pip install beautifulsoup4==4.4.0
pip install requests==2.7.0

echo "Cityscrape setup complete!"