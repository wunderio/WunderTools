# WunderTools structure and components

## Overview
![](img/wundertools_structure.png "WunderTools structure")

## WunderMachina
WunderMachina is a separate repository that is cloned under your project root (under the ansible folder). Invoking build.sh (either directly or through vagrant commands) or provision.sh will download / update this repository to the latest version unless otherwise defined. You can define which version (branch, tag or commit) will be used in the conf/project.yml file. Additionally, it is also possible to use an entirely different provisioning configuration - as long as it's compatible - by defining the repository in ansible: remote in the same place.

## Local environment
By default Vagrant is used for the local development environment. WunderTools Vagrant configuration supports either Virtualbox or VMWare Fusion backends for virtualization. Local vagrant configurations can be defined in conf/vagrant_local.yml. Support for docker based local environments is currently under work.

### Build.sh
build.sh is usually not intended to be run directly but through certain vagrant commands automatically (up, provision). Main function of build.sh is to clone WunderMachina's ansible roles and keep them up to date. It also has a self update mechanism and changelog functionality that will prompt users to comply with latest updates whenever there are upstream changes that require an action on the project side.

Additionally, the build.sh can be invoked directly for the following two cases:

1. Update
  ```./build.sh up```
  This will run  a self update check on build.sh and also bring the WunderMachina up to date with the latest defined version.

2. Reset
  ```./build.sh reset```
  This will reset the project to the default state removing any extra files downloaded by itself. It will also destroy any running vagrant boxes related to the project.


## Provisioning
Ansible is used for provisioning both local and remote environments. Configuration is divided into a shared conf/variables.yml that can define common configurations between environments, and environment specific conf/[environment].yml files that can define configurations unique to that environment. Additionally Ansible-vault can be used to store environment specific confidential variables in conf/[environment]-vars.yml.

Ansible playbooks and roles are defined in WunderMachina, but additional project specific roles can be defined under local_ansible_roles.

You can also use roles from Ansible Galaxy by defining them in `conf/requirements.yml`. 
See more info [here](http://docs.ansible.com/ansible/latest/galaxy.html#installing-multiple-roles-from-a-file)

Provisioning a different environment can be done using provided provision.sh command. For example to provision a production environment you could simply run:
```./provision.sh production```

Note: if ansible-vault is used you need to either have the WT_ANSIBLE_VAULT_FILE environment variable defined or provide the path to your ansible vault-password-file with the -p option when running provision.sh.

For more information run ```./provision.sh -h```

## Drupal build & deployment
Everything Drupal related can be found under the drupal/ folder. This is so that only the necessary files can be easily deployed to remote environments. All drupal related configurations go under drupal/conf folder. The latest active build will be under drupal/current.

Building drupal is handled by the drupal/build.sh script that supports both drush make and composer based installations. In addition to building drupal build.sh can be used for additional deployment tasks ranging from copying additional files in place to restarting services. The build process can be configured in drupal/conf/site.yml.
