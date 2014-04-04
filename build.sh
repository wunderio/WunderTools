#!/bin/bash

param="$@"

if [ -z "$WKV_SITE_ENV" ]; then

	dir="ansible/playbook"

	if vagrant status|grep default|egrep -q "not running|not created|sus"; then
		vagrant up
	fi

	vagrant ssh -c "cd /vagrant/drupal;./build.sh $param"

	if [ "$param" == "new" ]; then
		vagrant ssh -c "sudo service varnish restart"	
	fi

else

	cd drupal
	./build.sh $param

fi
