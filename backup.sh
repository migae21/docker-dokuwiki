#!/bin/sh
 
backup_files="/var/dokuwiki-storage"
 
dest="/var/dokuwiki-backup"
 
day=$(date +%A)

archive_file="$day.tgz"
 
tar czf $dest/$archive_file $backup_files

