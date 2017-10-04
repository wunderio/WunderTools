Development instructions
========================

Clone the git repo and build the vagrant machine by running

vagrant up

Once the machine is built and provisioned you can login with

vagrant ssh

Git flow instructions
---------------------

By default we are using WunderFlow as our development workflow.
See [WunderFlow](http://wunderkraut.github.io/WunderFlow) for reference.

If the project uses something else please document it here.

Syncing database between environments
-------------------------------------

The `syncdb.sh` script can be used to sync the database between environments. See `./syncdb.sh -h` for usage and options. Also see contents of `syncdb_local.sh` for example of business logic included after sync.
