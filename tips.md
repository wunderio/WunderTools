### Useful things

Add this to your /etc/sudoers (it is recommended to use `visudo` command to edit that file!) to skip sudo password prompts during vagrant operations:
```
# Vagrant sudoers config
Cmnd_Alias VAGRANT_EXPORTS_ADD = /usr/bin/tee -a /etc/exports
Cmnd_Alias VAGRANT_NFSD = /sbin/nfsd restart
Cmnd_Alias VAGRANT_EXPORTS_REMOVE = /usr/bin/sed -E -e /*/ d -ibak /etc/exports
Cmnd_Alias VAGRANT_HOSTS_ADD = /bin/sh -c echo "*" >> /etc/hosts
Cmnd_Alias VAGRANT_HOSTS_REMOVE = /bin/sed -i -e /*/ d /etc/hosts
%admin ALL=(root) NOPASSWD: VAGRANT_EXPORTS_ADD, VAGRANT_NFSD, VAGRANT_EXPORTS_REMOVE, VAGRANT_HOSTS_ADD, VAGRANT_HOSTS_REMOVE
```


Attention: This might be out of date. Updated version coming soon!

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
        You can setup the dir where the docs are taken from and their URL in the
        variables.yml file.

        #Docs
        docs:
          hostname : 'docs.local.ansibleref.com'
          dir : '/vagrant/docs'
