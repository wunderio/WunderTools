#!/usr/bin/env bash

# Production server
prod_server=prod-front-1.yrittajat.hel.upc.wunder.io

# We are using yesterday's backup
if [ "$(uname)" == "Darwin" ]; then
   daybefore=$(date -v -1d '+%y-%m-%d')
else
   daybefore=$(date -d "1 day ago" '+%y-%m-%d')
fi


# Backups directory - Make sure this is correct
backup_dir=/nfs-files/backups/drupal/database/$daybefore

backup_file=$(ssh www-admin@$prod_server "ls -t $backup_dir/wundertools* | xargs -n 1 basename")

echo "Getting the latest database..."
scp www-admin@$prod_server:$backup_dir/$backup_file drupal/

echo "Importing into Lando"
cd drupal && lando db-import $backup_file
echo "You can delete $backup_file now"

lando drush en devel dblog stage_file_proxy --yes;
echo 'Enabled Devel, DBlog and Stage File Proxy modules.';
