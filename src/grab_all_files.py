'''
    @author: clayton.young, dylan.raithel
    deps: run cityscrape-setup.sh

'''

# Base Imports
import re
import os
import sys
import logging

# Third Party Imports
from bs4 import BeautifulSoup
import requests

# Modules
from util.log import configure_log

# Globals
WORKDIR = os.environ['WORKDIR']
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
        logger.info("Link: {}".format(link))

        filename = '/'.join([WORKDIR, link])

        download_link = source_files + link
        logger.info('url: {}'.format(download_link))

        if os.path.isfile(filename) == True:
            logger.info('File: {} already exists'.format(link))

        else:
            logger.info('Downloading ' + link)
            try:
                request = requests.get(download_link, stream=True)
            except requests.exceptions.ConnectionError as err:
                logger.warn("Manually Raised Error {}: {}".format(err.errno, err.strerror))
                break

            with open(filename, 'wb') as f:
                logger.info("Writing out to file: {}".format(filename))
                try:
                    for chunk in request.iter_content(chunk_size=1024):
                        if chunk:
                            f.write(chunk)
                            f.flush
                except requests.exceptions.ConnectionError as err:
                    logger.warn("Error: {} | {}".format(err.errno, err.strerror))
                    break


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

    logger.info('CityScrape download complete!')


if __name__ == '__main__':
    main()
