'''
    @author: clayton.young, dylan.raithel
    deps: run cityscrape-setup.sh

'''

# Base Imports
import re
import wget
import os
import sys
import logging

# Third Party Imports
from bs4 import BeautifulSoup
import requests

# Modules
from util.log import configure_log

# Globals
OUTPUT_DIR = os.environ['OUTPUT_DIR']
SOURCEFILE_URL = os.environ['SOURCEFILE_URL']


def get_soup():
    '''
        Input: None
        Output: html-like BeautifulSoup object

    '''
    source_files = SOURCEFILE_URL

    logger = logging.getLogger(__name__)
    logger.info('Scraping ' + source_files + ' for .zip files')

    resp = requests.get(source_files)
    encoding = resp.encoding if 'charset' in resp.headers.get('content-type', '').lower() else None
    soup = BeautifulSoup(resp.content, from_encoding=encoding)

    return soup


def get_files(soup):
    '''
        Input: html-like BeautifulSoup object
        Output: Download a bunch o' files

    '''
    source_files = SOURCEFILE_URL

    logger = logging.getLogger(__name__)

    for endpoint in soup.find_all('a', href=re.compile("\.zip")):
        link = endpoint['href']

        if os.path.isfile(link) == False:
            logger.info('Downloading ' + link)

            filename = OUTPUT_DIR + link

            download_link = source_files + link
            logger.info('Http endpoint: {}'.format(download_link))

            request = requests.get(download_link, stream=True)

            with open(filename, 'wb') as f:
                for chunk in request.iter_content(chunk_size=1024):
                    if chunk:
                        f.write(chunk)
                        f.flush

    logger.info('All zip files downloaded from ' + source_files)


def main():
    '''
        Main module gathers new raw files for ingest into CityScrapeDB

    '''
    configure_log()
    logger = logging.getLogger(__name__)

    logger.info('Executing initial page scrape to look for new files...')
    soup = get_soup()

    logger.info('Fetching files now!')
    get_files(soup)

    logger.info('CityScrape complete!')


if __name__ == '__main__':
    main()
