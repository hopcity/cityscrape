#!/usr/bin/env python
#
# GrabAllFiles.py
#
# Scrape the StlCity Open Data page for all the .zip files and download
#


from bs4 import BeautifulSoup
import requests
import re
import wget
import os

os.chdir('/home/clay/Downloads/stlCity')

source_files = "http://dynamic.stlouis-mo.gov/citydata/downloads/"


print '\nScraping ' + source_files + ' for .zip files'
resp = requests.get(source_files)
encoding = resp.encoding if 'charset' in resp.headers.get('content-type', '').lower() else None
soup = BeautifulSoup(resp.content, from_encoding=encoding)
os.chdir('zipFiles')
for link in soup.find_all('a', href=re.compile("\.zip")):
    download_link = source_files + link['href']
    if os.path.isfile(link['href']) == False: 
        print '\nDownloading ' + link['href']
        wget.download(download_link)

print '\nAll *.zip files downloaded from ' + source_files
os.chdir('..')
