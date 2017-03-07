#!/bin/bash
function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

# Local dependencies:
# - drush
# - rsync
# - drush aliases (automatically setup with `vagrant up`)

pushd `dirname $0` > /dev/null
ROOT=`pwd -P`
popd > /dev/null

PROJECTCONF=$ROOT/conf/project.yml
eval $(parse_yaml $PROJECTCONF)

if [ $# -gt 0 ]; then
  SOURCE="@$project_name.$1"
  if [ $# -eq 2 ]; then
    if [ $2 == 'prod' ]; then
      echo "You tried to sync to a production environment!"
      echo "This is probably newer the intention, so we always fail such attempts."
      exit
    fi
    TARGET="@$project_name.$2"
  else
    TARGET="@$project_name.local"
  fi
else
  SOURCE="@$project_name.prod"
  TARGET="@$project_name.local"
fi

drush $SOURCE dumpdb --structure-tables-list=cache,cache_*,history,sessions,watchdog --dump-dir=/tmp/syncdb/drupal

# Make sure the tmp folder exists on the machine where this script is run so that rsync will not fail.
mkdir -p /tmp/syncdb/drupal

# Make sure the tmp folder is created in the target machine
drush $TARGET ssh "mkdir -p /tmp/syncdb/drupal"

# --compress-level=1 is used here as testing shows on fast network it's enough compression while at default level (6) we are already bound by the cpu
# on slow connections it might still be worth to use --compress-level=6 which could save around 40% of the bandwith
drush -y rsync --mode=akzi --compress-level=1 $SOURCE:/tmp/syncdb/drupal /tmp/syncdb/drupal
drush -y rsync --mode=akzi --compress-level=1 /tmp/syncdb/drupal/ $TARGET:/tmp/syncdb/drupal

# Let's not use -y here yet so that we have at least one confirmation in this
# script before we destroy the $TARGET data.
drush $TARGET sql-drop
drush $TARGET importdb --dump-dir=/tmp/syncdb/drupal

# Sanitize users.
drush $TARGET sqlq "UPDATE users SET mail = 'user@example.com' WHERE name != 'admin'"
drush $TARGET sqlq "UPDATE users SET init = '' WHERE name != 'admin'"
drush $TARGET sqlq "UPDATE users SET pass = '' WHERE name != 'admin'"
drush $TARGET upwd admin --password=admin
echo 'Sanitized users.'

# Enable Stage File Proxy.
drush $TARGET pm-download --yes stage_file_proxy;
drush $TARGET pm-enable --yes stage_file_proxy;
drush $TARGET variable-set stage_file_proxy_origin "$project_file_sync_url";
echo 'Enabled Stage File Proxy.'
