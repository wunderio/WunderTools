#!/bin/bash

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
set -ex

rm -Rf ~/.drush
mkdir -p ~/.drush/sites

ln -s /app/drush/sites/self.site.yml ~/.drush/sites/self.site.yml
drush cc drush
