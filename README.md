# Project reference setup with Ansible & Vagrant

[![Build Status](https://travis-ci.org/wunderkraut/WunderMachina.svg)](https://travis-ci.org/wunderkraut/WunderMachina)
[![Build Status](https://travis-ci.org/wunderkraut/WunderTools.svg)](https://travis-ci.org/wunderkraut/WunderTools)

# Starting a new Drupal 7 Project with WunderTools

## Preparation
Start by downloading a zipball of the WunderTools master branch as a base for your new project from
https://github.com/wunderkraut/WunderTools/archive/master.zip

If you already have an empty git repository, you can move the contents of WunderTools-master into
your git repo directory (Excercise to reader: Find a way to move content + dotfiles in one command that works in all shells). 

  `mv WunderTools-master/* ~/Projects/my-new-project`
  `mv WunderTools-master/.* ~/Projects/my-new-project`

If not, rename WunderTools-master to whatever project folder you have and run git init inside it:

  ```
  mv WunderTools-master ~/Projects/my-new-project
  cd ~/Projects/my-new-project
  git init
  ```
  

## Configure WunderTools

Edit `conf/vagrant_local.yml` and change: 
 - name to the name of your project
 - hostname to a good hostname for your local environment
 - ip to something that no other project in your company uses

Edit `conf/vagrant.yml`, find&replace "wundertools" with you project name.

Edit `conf/project.yml` and change the variables to something that makes sense for your project.
 
```
project:
  name: wundertools
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

Edit `drupal/conf/site.make`, remove things you don't need and add stuff you want in your project.

Edit `drupal/conf/site.yml`, remove things you don't need and add stuff you want in your project.

Rename `drupal/conf/wundertools.aliases.drushrc.php` to `project_name` and configure it to fit your setup. This will be
 automatically symlinked from ~/.drush when running vagrant up.

## Finishing up
Delete this section of Readme.md because it does not affect developers joining an already configured project. And move
on to the next section! 

# Getting your new local development environment up and running

Find the IP-address and hostname that this local environment is configured to use from `conf/vagrant_local.yml` and add
it to your own `/etc/hosts` file:

`10.0.13.37 local.wundertools.com`

Let Vagrant create your new machine:

`vagrant up`

This will create a new Virtual machine on your computer, configure it with all the nice bells & whistles that you can
think of (like MariaDB, nginx, Varnish, memcached and whatnot) and start it up for you. This will also install vagrant plugin depedencies, if you encounter issues while installing the plugins then you could use: `vagrant --skip-dependency-manager up`

SSH into your box and build and install Drupal: 

```
vagrant ssh
cd /vagrant/drupal
./build.sh new
```

If this is a project with an existing production/staging server, you should probably sync the production database now,
from your local machine: 

`sync.sh`

### Requirements
A working combination of:
- Vagrant
- The vagrant-cachier plugin https://github.com/fgrehm/vagrant-cachier
( $ vagrant plugin install vagrant-cachier )
- Ansible in your host machine. For OS X:
 brew install ansible
- Virtualbox (or Wmware)

#### Working version combinations

We depend of different software that gets constantly and independently updated, so it's not trivial to know which versions work well together.
At the time of writing (dec 9 2016) these are combinations that are known to work (there might be others):

- virtualbox 5.1, vagrant 1.9.0, ansible 2.2, geerlinguy box 1.1.4 (vagrant 1.9.1 should be avoided because of a bug that interferes with nfs mounting)
- virtualbox 5.0, vagrant 1.8.4, ansible 2.0.0.2, geerlingguy box 1.1.3 (vagrant > 1.8.4 has issues with nfs and keys)

If you are using different versions, you are on your own :)

##Introduction

Start by running:

```bash
$ vagrant up
```

This will do the following:

- clone the latest WunderMachina ansible/vagrant setup (or the version specified in conf/project.yml)
- Bring up & provision the virtual machine (if needed)
- Build the drupal site under drupal/current (not yet actually)

After finishing provisioning (first time is always slow) and building the site
you need to install the Drupal site in http://x.x.x.x:8080/install.php
(Note: on rare occasion php-fpm/varnish/e.g. requires to be restarted before
starting to work. You can do this by issuing the following command:

```bash
$ vagrant  ssh -c "sudo service php-fpm restart"
$ vagrant  ssh -c "sudo service varnish restart"
```


All Drupal-related configurations are under drupal/conf

Drush is usable without ssh access with the drush.sh script e.g:

```bash
$ ./drush.sh cc all
```

To open up ssh access to the virtual machine:

```bash
$ vagrant ssh
```

-------------------------------------------------------------------------------
Useful things

At the moment IP is configured in
  Vagrantfile
    variable INSTANCE_IP

Varnish responds to
  http://x.x.x.x/

Nginx responds to
  http://x.x.x.x:8080/

Solr responds to
  http://x.x.x.x:8983/solr

MailHOG responds to
  http://x.x.x.x:8025

Docs are in
        http://x.x.x.x:8080/index.html
        You can setup the dir where the docs are taken from and their URL from the
        variables.yml file.

        #Docs
        docs:
          hostname : 'docs.local.wundertools.com'
          dir : '/vagrant/docs'


##Vagrant + Ansible configuration

Vagrant is using Ansible provision stored under the ansible subdirectory.
The inventory file (which stores the hosts and their IP's) is located under
ansible/inventory. Host specific configurations for Vagrant are stored in
ansible/vagrant.yml and the playbooks are under ansible/playbook directory.
Variable overrides are defined in ansible/variables.yml.

You should only bother with the following:

  Vagrant box setup
    conf/vagrant.yml

  What components do you want to install?
    conf/vagrant.yml

  And how are those set up?
    conf/variables.yml

You can also fix your vagrant/ansible base setup to certain branch/revision
    conf/project.yml
  There you can also do the same for build.sh



## Debugging tools

XDebug tools are installed via the devtools role. Everything should work out
of the box for PHPStorm. PHP script e.g. drush debugging should also work.

Example Sublime Text project configuration (via Project->Edit Project):

    {
       "folders":
       [
         {
           "follow_symlinks": true,
           "path": "/path/to/wundertools"
         }
       ],

       "settings":
       {
         "xdebug": {
              "path_mapping": {
                    "/vagrant" : "/path/to/wundertools"
                 }
            }
          }
    }
