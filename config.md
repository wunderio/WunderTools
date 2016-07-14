# Configuration

Attention: More detail coming soon!


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

Example sublime text project configuration (via Project->Edit Project):

    {
       "folders":
       [
         {
           "follow_symlinks": true,
           "path": "/path/to/ansibleref"
         }
       ],

       "settings":
       {
         "xdebug": {
              "path_mapping": {
                    "/vagrant" : "/path/to/ansibleref"
                 }
            }
          }
    }

