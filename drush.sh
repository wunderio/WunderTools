#!/bin/bash

params=''
for i in "$@";do
    params="$params \"${i//\"/\\\"}\""
done;


if [ -z "$WKV_SITE_ENV" ]; then

	if ! vagrant status|grep default|grep -q running; then
		echo "Vagrant is not up!"
		exit 1
	fi

	vagrant ssh -c "cd /vagrant/drupal/web/;drush $params"

else

	cd drupal/web
	drush $params

fi

