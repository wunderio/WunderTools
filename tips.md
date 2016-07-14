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
          hostname : 'docs.local.ansibleref.com'
          dir : '/vagrant/docs'


