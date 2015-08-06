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
export GITHUB_URL='https://github.com/hopcity/cityscrape/'
export SOURCEFILE_URL='http://dynamic.stlouis-mo.gov/citydata/downloads/'

# temporary file download and extraction before loading into database
export OUTPUT_DIR=$BASEDIR/stl_city_files/

