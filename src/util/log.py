import logging
import sys
from datetime import datetime


def configure_log():
    """Sets up the log system to have a consistent format and output"""
    format = "%(asctime)s|%(name)13s:%(levelname)-7s| %(message)s"

    cur_date = datetime.now()
    today_string = cur_date.strftime('%Y-%m-%d')

    # Configure our logger so it has a useful format
    logging.basicConfig(level=logging.DEBUG, format=format)
