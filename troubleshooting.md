##Troubleshooting
If you encounter any problems first things to check:
1. Does the build.sh point to wunderkraut github account when it tries to download drupal/build.sh?
This could lead into such problems as trying to run drupal/build.sh: ./build.sh: line 1: Not: command not found"
There are 2 lines late in the build.sh like this:
curl -o drupal/build.sh https://raw.githubusercontent.com/wunderkraut/build.sh/$buildsh_revision/build.sh
Make sure it says wunderkraut there and not tcmug in both of them

2. Check the conf/project.yml ansible remote config, make sure it doesnt point to gitlab (unless you are 100% sure it should, some projects might have custom ansible configs) Default is git@github.com:wunderkraut/WunderMachina.git 

3. Still don’t get new updated ansible configs? If you have build the project previously with ansible remote pointing to wrong git remote you probably still have ansible/ folder from that old remote. Simply remove the whole ansible folder and run vagrant provision.

4.  Ansible complains about ssh authentication failure / private key etc.
Make sure you have vagrant 1.7+ installed
Make sure you are using latest ansible confs (see above)
You might need to destroy your old box for new private key to take effect.
Make sure you have symlinked you aliases file, not copied it.

5. Vagrant complains about network address already in use-
You probably have another projects vagrant box running with the same ip configured. Check conf/vagrant_local.yml and change the ip to something else.
Note: we try to keep this ip per box as a running number, but there are sometimes multiple projects coming in at the same time that double allocation might happen.
Note2: When starting project always update ansibleref repos default conf to next free ip!

6. If you get error about not able to load vagrantfile.rb:
Ensure you have correct repo url in conf/project.yml (see above)
Ensure you have your key added to your github account.

7. NFS shares should not be one inside the other:
If you have multiple projects and NFS shares in your host machine, check that no share is inside another one, because NFS definitely does not like that. 
