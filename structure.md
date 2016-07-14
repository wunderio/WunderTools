# WunderTools structure and components

## Overview
![](img/wundertools_structure.png "WunderTools structure")

## WunderMachina
WunderMachina is separate repository that is cloned under project root (under ansible folder). Invoking build.sh (either directly or through vagrant commands) or provision.sh will download / update shit repository to the latest version unless otherwise defined. You can define which version (branch, tag or commit) will be used in the conf/project.yml file. Additionally it is also possible to use entirely different provisioning configuration as long as it's compatible by defining the repository in ansible: remote in the same place.

## Local environment
By default Vagrant is used for local development environment. WunderTool Vagrant configuration supports either Virtualbox or VMWare Fusion backends for virtualization. Local vagrant configurations can be defined in conf/vagrant_local.yml. Support for docker based local environments is currently under work.


## Provisioning
Ansible is used for provisioning both local and remote environments. Configuration is divided into shared conf/variables.yml that can define common configurations between environments and environment specific conf/[environment].yml files that can define configurations unique to that environment. Additionally Ansible-vault can be used to store environment specific confidential variables in conf/[environment]-vars.yml.

Ansible playbooks and roles are defined in WunderMachina, but additional project specific roles can be defined under local_ansible_roles.

Provisioning different environment can be done using provided provision.sh command. For example to provision a production environment you could simply run:
```./provision.sh production```

Note: if ansible-vault is used you need to either have WT_ANSIBLE_VAULT_FILE environment variable defined or provide the path to your ansible vault-password-file with the -v option in provision.sh.

For more information run ```./provision.sh -h```

## Drupal build & deployment
Everything Drupal related can be found under drupal/ folder. This is so that only the necessary files can be easily deployed to remote environments. All drupal relaed configurations go under drupal/conf folder. Latest active build will be under drupal/current. 

Building drupal is handled by the drupal/build.sh script that supports both drush make and composer based installations. In addtion to building drupal build.sh can be used for additional deployment tasks ranging from copying additional files in place to restarting services. Build process can be configured in drupal/conf/site.yml.
