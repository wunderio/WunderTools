# Wundertools D8

### Requirements:
- Vagrant 1.7.x
- https://github.com/fgrehm/vagrant-cachier
( $ vagrant plugin install vagrant-cachier )
- Ansible in your host machine. For OS X:
 brew install ansible

### Getting started

##### 1. Setup the local vagrant environment

Start by running:

```$ vagrant up```

If everything went well, proceed to step 2.

##### 2. Setup the drupal project for the first time

SSH to your local vagrant environment:

```$ vagrant ssh```

Create a files directory under drupal:

```$ mkdir /vagrant/drupal/files```

Install the drupal project from configuration and create root directory (you only need to do this once):

```$ cd /vagrant/drupal/ && ./build.sh install```

This will/should generate the packages and project directory, and also install drupal using config_installer profile.

If you get some errors during build you can try to rebuild cache with "drush cr" and just login at https://local.wundertools.site


Sync database:

```$ ./sync.sh```

### Install and building composer packages

Composer commands could be done inside or outside the vagrant environment from /drupal/current directory.

Installing or updating packages

```composer require <package>```

Downloading packpages

```composer install```

### Configuration management

Importing configuration (this will override your current configuration):

```$ ./drush.sh cim```

Exporting configuration:

```$ ./drush.sh cex```

Note: Please take care when committing exported configuration code, making sure you are not overriding configuration that were not related to the changes that you have made.

### Deploying in staging/production

```./build.sh update```
