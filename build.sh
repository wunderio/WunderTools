#!/bin/bash

dir="ansible/playbook"

if ! vagrant status|grep default|grep -q running; then
	cd $dir
	if [ ! -f vagrant.yml ]; then
		echo "Symlink playbook for vagrant."
		ln -s ../vagrant.yml vagrant.yml 
	fi
	cd -
	vagrant up
fi

param=$1
vagrant ssh -c "cd /vagrant/drupal;./build.sh $param"

if [ "$param" == "new" ]; then
	vagrant ssh -c "sudo service varnish restart"	
fi