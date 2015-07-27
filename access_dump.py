'''
  @author: clayton.young
  deps: apt-get mdbtools

  A simple script to dump the contents of a Microsoft Access Database.

'''
import sys
import subprocess


def csv_dump(tables, DATABASE):
    '''
      input: list of tables
      output: write out to file

      Dump each table as a CSV file using "mdb-export"
      converting " " in table names to "_" for the CSV filenames.

    '''
    for table in tables:
        if table != '':
            filename = table.replace(" ", "_") + ".csv"
            file = open(filename, 'w')
            print("Dumping " + table)
            contents = subprocess.Popen(["mdb-export", DATABASE, table],
                                        stdout=subprocess.PIPE).communicate()[0]
            file.write(contents)
            file.close()


def main():
    '''
      execute main

    '''

    if not sys.argv[1]:
        print 'this script requires a single argument, the database to connect to...'
        sys.exit(1)
    else:
        DATABASE = sys.argv[1]

    # Get the list of table names with "mdb-tables"
    table_names = subprocess.Popen(["mdb-tables", "-1", DATABASE],
                                   stdout=subprocess.PIPE).communicate()[0]

    tables = table_names.split('\n')

    csv_dump(tables)


if __name__ == '__main__':
    main()
