# Variables for the cityscrape

# Postgresql Database Settings
# make sure you have enabled PostGIS
export DATABASE_HOST='localhost'
export DATABASE_NAME='city'
export DATABASE_USER='postgres'
export DATABASE_PASSWORD=''

# URL housing zip files of open city data
export SCRAPE_URL='https://github.com/hopcity/cityscrape/'

# Directory in which scripts residek and a subfolder, 'zipFiles' exists
# for temporary file download and extraction before loading into database
export BASE_DIR='/home/clay/Downloads/stlCity/'

