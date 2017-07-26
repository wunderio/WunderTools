# Project reference setup with ansible & vagrant

[![Build Status](https://travis-ci.org/wunderio/WunderTools.svg?branch=master)](https://travis-ci.org/wunderio/WunderTools)
##Introduction


-------------------------------------------------------------------------------

## Features
- Local development environment
- Server provisioning
- Server configuration management
- Secrets management
- Testing
- Documentation

-------------------------------------------------------------------------------


## Requirements
- Vagrant
- Virtualbox or VMWare Fusion
- Ansible

### Optional
- To speed things up you might want to use vagrant-cachier
```vagrant plugin install vagrant-cachier```

- WunderTools supports vagrant-hostmanager for easier hosts configuration
```vagrant plugin install vagrant-hostmanager```

  Note: If you don't use hostmanager you need to take care of setting up your local environment hostname manually in /etc/hosts

## Getting help
Any suggestions, feedback and bug reports should be posted to Github issues: https://github.com/wunderio/WunderTools/issues

