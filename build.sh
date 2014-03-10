#!/bin/bash

param=$1

if [ -z "$WKV_SITE_ENV" ]; then

	dir="ansible/playbook"

	if vagrant status|grep default|egrep -q "running|not created"; then
		cd $dir
		if [ ! -f vagrant.yml ]; then
			echo "Symlink playbook for vagrant."
			ln -s ../vagrant.yml vagrant.yml 
		fi
		cd -
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