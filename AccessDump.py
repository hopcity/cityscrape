#!/usr/bin/env python
#
# AccessDump.py
# A simple script to dump the contents of a Microsoft Access Database.
# It depends upon the mdbtools suite:
#   http://sourceforge.net/projects/mdbtools/
 
import sys, subprocess # the subprocess module is new in python v 2.4
 
DATABASE = sys.argv[1]
 
# Get the list of table names with "mdb-tables"
table_names = subprocess.Popen(["mdb-tables", "-1", DATABASE], 
                               stdout=subprocess.PIPE).communicate()[0]
tables = table_names.split('\n')
 
# Dump each table as a CSV file using "mdb-export",
# converting " " in table names to "_" for the CSV filenames.
for table in tables:
    if table != '':
        filename = table.replace(" ","_") + ".csv"
        file = open(filename, 'w')
        print("Dumping " + table)
        contents = subprocess.Popen(["mdb-export", DATABASE, table],
                                    stdout=subprocess.PIPE).communicate()[0]
        file.write(contents)
        file.close()
