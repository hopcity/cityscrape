CONFIGFILE="config/cityscrape-config.sh"

. $CONFIGFILE

pushd $DDL_FILES

files=$(echo `ls *.mdb 2>/dev/null`)

if [[ -z "$files" ]]; then
  echo "No Schema Definitions Found, Exiting..."
  exit 3
else
  for file in $files
    do
      cat $file | tr -d "[]" > $file.sql
    done
fi

popd