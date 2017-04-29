'''
@author dylan.raithel
@date 2 Sep 2015

"Marshall" the Access types to Postgresql

'''

import re
import sys


def test_typeMap():
    # from marshall import typeMap

    file_name = '../workdir/ddl/prcl.mdb.sql'

    mapper = typeMap()

    mapper.handle_file(file_name)


class typeMap(object):

    SUFFIX = 'postgres.sql'
    PATH = '../workdir/ddl/'

    def __init__(self, file_name):

        self.file_name = file_name

    def convert_file(self):
        '''
        Iterate over all the ddl files in the working directory that
        need typeMap conversion
        '''
        self._handle_file(self.file_name)

    def _handle_file(self, file_name):

        self.mapper = self._access_to_postgres()
        filepath = self.PATH + file_name
        with open(filepath, 'r') as raw:
            sqlmap = dict((
                re.escape(k), v) for k, v in self.mapper.iteritems())

            pattern = re.compile("|".join(sqlmap.keys()))

            text_stream = raw.read()

            text = pattern.sub(
                lambda m: sqlmap[re.escape(m.group(0))], text_stream)

            newfilename = '{}_{}'.format(file_name, self.SUFFIX)

            with open(newfilename, 'w') as newfile:
                newfile.write(text)

    def _access_to_postgres(self):
        '''
        Return a map of MSsql data types to Posqgresql

        '''
        dictmap = {"Double": "Varchar", "Integer": "Varchar",
                   "Byte": "Varchar", "Text (4)": "Varchar",
                   "Long Integer": "Varchar", "DateTime": "Varchar",
                   "Boolean NOT NULL": "Varchar",
                   "Text (2)": "Varchar", "Single": "Varchar",
                   "Double": "Varchar", "Text (22)": "Varchar",
                   "Text (8)": "Varchar", "Text (80)": "Varchar",
                   "Text (26)": "Varchar", "Text (18)": "Varchar",
                   "Currency": "Varchar"}
        return dictmap

def main():

    file_name = sys.argv[1]

    mapper = typeMap(file_name)

    mapper.convert_file()


if __name__ == '__main__':
    main()
