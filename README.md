# Wundertools Project

## Quick start

 ### Lando

Converting existing project into new WunderTools-Composer? Go here: [Converting Drupal7 Projects](https://github.com/wunderio/WunderTools/blob/drupal7/docs/converting-d7-projects.md)

Fire up Lando environment

    $ cd drupal
    $ lando start

If all goes well you can proceed to creating a new build.

    $ lando build.sh build

Synchronise the database from production.

    $ cd .. && ./syncdb_lando.sh

Navigate to <https://wundertools.lndo.site>

### Vagrant - This is untested after lando update

Fire up the vagrant environment

    $ vagrant up

If all goes well you can proceed to creating a new build inside vagrant.

    $ vagrant ssh
    $ cd /vagrant/drupal
    $ ./build.sh build

Synchronise the database from production .

    $ cd .. && ./sync.sh

Navigate to <https://local.wundertools.fi>
