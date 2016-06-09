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

Build the drupal project:

```$ cd /vagrant/drupal/ && ./build.sh new```

Install from minimal profile (for fresh install):

```$ cd /vagrant/drupal/current/web && drush si minimal --config-dir=../staging```

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

```$ ./drush.sh cim staging```

Exporting configuration:

```$ ./drush.sh cex staging```

Note: Please take care when committing exported configuration code, making sure you are not overriding configuration that were not related to the changes that you have made.

### Deploying in staging/production

```./build.sh update```
