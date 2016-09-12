# Wundertools D8

## Starting a new Drupal 8 Project with WunderTools

### Preparation

Start by downloading a zipball of the WunderTools d8 branch as a base for your new project from
https://github.com/wunderkraut/WunderTools/archive/d8.zip

If you already have an empty git repository, you can move the contents of WunderTools-d8 into your git repo
directory (Excercise to reader: Find a way to move content + dotfiles in one command that works in all shells).

`mv WunderTools-d8/* ~/Projects/my-new-project mv WunderTools-d8/.* ~/Projects/my-new-project`

If not, rename WunderTools-d8 to whatever project folder you have and run git init inside it:
```
  mv WunderTools-d8 ~/Projects/my-new-project
  cd ~/Projects/my-new-project
  git init
```

## Configure WunderTools

Edit `conf/vagrant_local.yml` and change:
 - name to the name of your project
 - hostname to a good hostname for your local environment
 - ip to something that no other project in your company uses

Edit `conf/project.yml` and change the variables to something that makes sense for your project.

```
project:
  name: ansibleref
ansible:
  remote: https://github.com/wunderkraut/WunderMachina.git
  branch: master # Master branch is for CentOS 7. If you want CentOS 6, use centos6 branch.
  revision:
buildsh:
  enabled: true
  branch: develop # Supports both Drupal 8 and Drupal 7.
  revision: # As with composer.lock, could be a good idea to use a specific git revision.
wundertools:
  branch: master
externaldrupal:
  remote:
  branch:
```

## Configure Drupal build

Edit `drupal/conf/site.yml`, remove things you don't need and add stuff you want in your project.

Rename `drupal/conf/ansibleref.aliases.drushrc.php` to `project_name` and configure it to fit your setup. This will be
 automatically symlinked from ~/.drush when running vagrant up.

## Install Drupal 8 for the first time
1. SSH to vagrant and go to `/vagrant/drupal`.
2. Run `./build.sh new` to generate the project directory and install drupal from configuration.
3. Profit! You should now be able to access your site through https://yoursite-hostname or http://yoursite-hostname:8080

## Finishing up
Delete this section of Readme.md because it does not affect developers joining an already configured project. And move
on to the next section!

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

```$ cd /vagrant/drupal/ && ./build.sh new```

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

### Updating Drupal core

```composer update drupal/core --with-dependencies```

### Configuration management

Importing configuration (this will override your current configuration):

```$ ./drush.sh cim```

Exporting configuration:

```$ ./drush.sh cex```

Note: Please take care when committing exported configuration code, making sure you are not overriding configuration that were not related to the changes that you have made.

### Deploying in staging/production

```./build.sh update```
