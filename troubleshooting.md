# Troubleshooting / FAQ

WunderTools moves fast and is used in many different projects, so issues emerge. Here we collect the most common pitfalls and the solutions to them.

### Frequently Asked Questions ###


* #### Varnish repo is outdated ####
Symptom: provision fails
Old official repo.varnish-cache.org repo is deprecated. This might lead to existing environments provisioning to fail even as we have already fixed the issue in the wundermachina. The fix is to ensure the target environment doesn't have reference to the old repo anymore by either running `sudo yum-config-manager --disable varnish-4.1` or manually removing the `/etc/yum.repos.d/varnish.repo` and reprovisioning varnish again (`./provision.sh -t varnish [env]`)


* #### key.wunder.io issues ####
Symptom: `curl: (6) Could not resolve host: key.example.tld; Name or service not known"], "stdout":`
Solution: Due to changes in defaults for key.wunder.io ansible role all projects need to add `base_pubkeys_enable: False` to their `conf/vagrant.yml` variables.

* #### Drupal console and/or codeception issues ####
Export the db credentials:
`export DB_USER_DRUPAL=drupal`
`export DB_PASS_DRUPAL=password`

* #### More info out of the standard "power plug" page ####
While "our best people are on the case", if you want to have more error information you can:  append `?error-debug=randomvar` to the end of an url to see the original error message.

* #### Does the build.sh point to wunderio github account when it tries to download drupal/build.sh? ####
This could lead into this kind of symptom when trying to run drupal/build.sh: ./build.sh: line 1: Not: command not found"`
There are 2 lines late in the build.sh script like this:
`curl -o drupal/build.sh https://raw.githubusercontent.com/wunderio/build.sh/$buildsh_revision/build.sh`
Make sure it says wunderio there and not tcmug in both of them

* #### Generally, your project.yml file should not point to gitlab ####
Check the conf/project.yml ansible remote config, make sure it doesn't point to gitlab (unless you are 100% sure it should, some projects might have custom ansible configs) Default is git@github.com:wunderio/WunderMachina.git

* #### My project is not getting updated ansible configs! ####
Still don’t get new updated ansible configs? If you have build the project previously with ansible remote pointing to the wrong git remote you probably still have an ansible folder from that old remote. Simply remove the whole Ansible folder and run `vagrant provision`.

* #### Ansible complains about ssh authentication failure / private key etc. ####
Make sure you have vagrant 1.7+ installed.
Make sure you are using the latest ansible confs (see above)
You might need to destroy your old box for new private key to take effect.
Make sure you have symlinked your aliases file, not copied it.

* #### Vagrant complains about network address already in use ####
You probably have another project's vagrant box running with the same ip configured. Check conf/vagrant_local.yml and change the ip to something else to avoid conflicts.
We try to keep this ip per box as a running number, but there are sometimes multiple projects coming in at the same time and that might cause a double allocation.
When starting a project always update ansibleref repos default conf to next free ip!

* #### It says it can't load vagrantfile.rb! ####
Ensure you have the correct repo url in conf/project.yml (see above)
Ensure you have your public key added to your github account.

* #### My NFS does not work! ####
If you have multiple projects and NFS shares in your host machine, check that **no share is inside another one**, because NFS definitely does not like that.

* #### I'm on linux and I get mount.nfs: requested NFS version or transport protocol is not supported####
(Linux specific) NFS times out or produces the following error message: `mount.nfs: requested NFS version or transport protocol is not supported`:
It could be that your OS has updated nfs-utils package to the latest upstream version which by default has UDP protocol support disabled. A quick fix is to edit `/etc/sysconfig/nfs` (Fedora) or `/etc/default/nfs-kernel-server` (Ubuntu) and add `--udp` to `RPCNFSDARGS` and then restart the NFS server.
