#!/bin/bash

fly -a sixa sftp get /data/production/data.sqlite3
fly -a sixa sftp get /data/production/data.sqlite3-shm
fly -a sixa sftp get /data/production/data.sqlite3-wal

timestamp=$(date +"%Y%m%d.%H%M%S")
zip -r "db.${timestamp}.zip" data.sqlite3 data.sqlite3-shm data.sqlite3-wal

rm data.sqlite3
rm data.sqlite3-shm
rm data.sqlite3-wal

for zip_file in db.*.zip; do
  mv "$zip_file" "/Volumes/Samsung/666a"
done

files=(/Volumes/Samsung/666a/*)
if [ ${#files[@]} -gt 4 ]; then
  oldest_file=$(ls -t /Volumes/Samsung/666a/* | tail -1)
  rm "$oldest_file"
fi

