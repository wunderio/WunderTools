#!/bin/bash

if ! vagrant status|grep default|grep -q running; then
	echo "Vagrant is not up!"
	exit 1
fi

params=''
for i in "$@";do 
    params="$params \"${i//\"/\\\"}\""
done;

vagrant ssh -c "cd /vagrant/drupal;drush $params"

