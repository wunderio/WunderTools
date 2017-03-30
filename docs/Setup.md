## Starting a new Drupal 8 Project with WunderTools

### Preparation

Start by downloading a zipball of the WunderTools d8 branch as a base for your new project from
https://github.com/wunderkraut/WunderTools/archive/d8.zip

If you already have an empty git repository, you can move the contents of WunderTools-d8 into your git repo
directory (Excercise to reader: Find a way to move content + dotfiles in one command that works in all shells).

`mv WunderTools-d8/* ~/Projects/my-new-project mv WunderTools-d8/.* ~/Projects/my-new-project`

If not, rename WunderTools-d8 to whatever project folder you have and run git init inside it:
```
  mv WunderTools-d8 ~/Projects/my-new-project
  cd ~/Projects/my-new-project
  git init
```

## Configure WunderTools

Edit `conf/vagrant_local.yml` and change:
 - name to the name of your project
 - hostname to a good hostname for your local environment
 - ip to something that no other project in your company uses

Edit `conf/project.yml` and change the variables to something that makes sense for your project.

```
project:
  name: ansibleref
ansible:
  remote: https://github.com/wunderkraut/WunderMachina.git
  branch: master # Master branch is for CentOS 7. If you want CentOS 6, use centos6 branch.
  revision:
buildsh:
  enabled: true
  branch: develop # Supports both Drupal 8 and Drupal 7.
  revision: # As with composer.lock, could be a good idea to use a specific git revision.
wundertools:
  branch: master
externaldrupal:
  remote:
  branch:
```

Edit `conf/develop.yml` and change the variables to something that makes sense for your project.

## Configure Drupal build

Edit `drupal/conf/site.yml`, remove things you don't need and add stuff you want in your project.

Rename `drupal/conf/ansibleref.aliases.drushrc.php` to `project_name` and configure it to fit your setup. This will be
 automatically symlinked from ~/.drush when running vagrant up.
