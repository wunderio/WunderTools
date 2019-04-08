# Wundertools

Reference setup for Drupal 8 projects. For Drupal 7 support, see the [Drupal 7 branch](https://github.com/wunderio/WunderTools/tree/drupal7).

[![Build Status](https://travis-ci.org/wunderio/WunderMachina.svg)](https://travis-ci.org/wunderio/WunderMachina)
[![Build Status](https://travis-ci.org/wunderio/WunderTools.svg)](https://travis-ci.org/wunderio/WunderTools)


## Requirements
- [Lando](https://docs.devwithlando.io/)

## Creating a new project

If you are starting a new project, see: [Setup.md](docs/Setup.md)


## Setting up an existing project locally

Start your local development environment:

`lando start`

For a list of available commands, just type `lando`.


### Lando debugging

XDebug can be enabled by uncommeting `xdebug: true` in the .lando.yml file. After `lando rebuild` port 9000 is used for XDebug.

Note: Make sure port 9000 is not used in your OS for anything else. You can see all ports in use for example with `lsof -i -n -P`. For example php-fpm might be using port 9000 if you have it running.
