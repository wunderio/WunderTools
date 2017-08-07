#!/usr/bin/env bash

# Local dependencies:
# - drush
# - rsync
# - drush aliases (automatically setup with `vagrant up`)

# Function to parse the project configuration yaml.
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

pushd `dirname $0` > /dev/null
ROOT=`pwd -P`
popd > /dev/null

PROJECTCONF=$ROOT/conf/project.yml
eval $(parse_yaml $PROJECTCONF)

# Example usage: ./syncdb.sh -p wundertools -s prod -t local
# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -p|--project-name)
    project_name="$2"
    shift # past argument
    ;;
    -s|--source)
    SOURCE="$2"
    shift # past argument
    ;;
    -t|--target)
    TARGET="$2"
    shift # past argument
    ;;
    --default)
    # DEFAULT=YES # just an example
    ;;
    *)
      # unknown option
    ;;
esac
shift # past argument or value
done

# Make sure we have the $project_name
if [ -z "$project_name" ]; then
  echo "Project name missing. Set in config or use -p flag."
  exit
fi

# Default $SOURCE to "prod".
if [ -z "$SOURCE" ]; then
  echo "Source defaults to 'prod'. You can set it with -s flag."
  SOURCE="@$project_name.prod"
else
  SOURCE="@$project_name.$SOURCE"
fi

# Default $TARGET to "local". Prevent "prod" and "production".
if [ -z "$TARGET" ]; then
  echo "Target defaults to 'local'. You can set it with -t flag."
  TARGET="@$project_name.local"
else
  if [ $TARGET == 'prod' ] || [ $TARGET == 'production' ]; then
    echo "You tried to sync to a production environment!"
    echo "This is probably never the intention, so we always fail such attempts."
    exit
  else
    TARGET="@$project_name.$TARGET"
  fi
fi

drush $SOURCE dumpdb --structure-tables-list=cache,cache_*,history,sessions,watchdog --dump-dir=/tmp/syncdb/drupal

# Make sure the tmp folder exists on the machine where this script is run so that rsync will not fail.
mkdir -p /tmp/syncdb/drupal

# Make sure the tmp folder is created in the target machine
drush $TARGET ssh "mkdir -p /tmp/syncdb/drupal"

# --compress-level=1 is used here as testing shows on fast network it's enough compression while at default level (6) we are already bound by the cpu
# on slow connections it might still be worth to use --compress-level=6 which could save around 40% of the bandwith
drush -y rsync --mode=akzi --compress-level=1 $SOURCE:/tmp/syncdb/drupal /tmp/syncdb/drupal
# Delete the exported sql files from the source for security.
drush $SOURCE ssh "rm -rf /tmp/syncdb/drupal"
drush -y rsync --mode=akzi --compress-level=1 /tmp/syncdb/drupal/ $TARGET:/tmp/syncdb/drupal
# Delete the exported sql files from the local machine for security.
rm -rf /tmp/syncdb/drupal

# Let's not use -y here yet so that we have at least one confirmation in this
# script before we destroy the $TARGET data.
drush $TARGET sql-drop
drush $TARGET importdb --dump-dir=/tmp/syncdb/drupal

# Delete the exported sql files from target for security.
drush $TARGET ssh "rm -rf /tmp/syncdb/drupal"

# Sanitize users.
drush $TARGET sqlq "UPDATE users SET mail = 'user@example.com' WHERE name != 'admin'"
drush $TARGET sqlq "UPDATE users SET init = '' WHERE name != 'admin'"
drush $TARGET sqlq "UPDATE users SET pass = '' WHERE name != 'admin'"
drush $TARGET upwd admin --password=admin
echo 'Sanitized users.'

# Include any project specific sync commands.
if [ -f syncdb_local.sh ]
then
  source syncdb_local.sh
fi

# Enable Stage File Proxy.
drush $TARGET pm-download --yes stage_file_proxy
drush $TARGET pm-enable --yes stage_file_proxy
drush $TARGET variable-set stage_file_proxy_origin "$project_file_sync_url"
echo 'Enabled Stage File Proxy.'

# Clear caches after sync.
drush $TARGET cache-clear all
