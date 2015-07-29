# Variables for the cityscrape

# Postgresql Database Settings
# make sure you have enabled PostGIS
export DATABASE_HOST='localhost'
export DATABASE_NAME='city'
export DATABASE_USER='postgres'
export DATABASE_PASSWORD=[redacted]

# Set up paths
export BASEDIR=`dirname "$0"`
export CITYSCRAPE_VIRTUALENV_DIR=$BASEDIR/.py-env

# URL housing zip files of open city data
# Is this the actual scrape URL? I don't think it is
export SCRAPE_URL='https://github.com/hopcity/cityscrape/'

# Directory in which scripts residek and a subfolder, 'zipFiles' exists
# for temporary file download and extraction before loading into database
export STL_CITY_DIR=$BASEDIR/stl_city

