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

# Set sync directory with timestamp to allow parallel syncing.
SYNCDIR="/tmp/syncdb/$project_name$(date +%s)"
echo "Using directory $SYNCDIR for syncing."

drush $SOURCE dumpdb --structure-tables-list=cache,cache_*,history,sessions,watchdog --dump-dir=$SYNCDIR

# Make sure the tmp folder exists on the machine where this script is run so that rsync will not fail.
mkdir -p $SYNCDIR

# Make sure the tmp folder is created in the target machine
drush $TARGET ssh "mkdir -p $SYNCDIR"

# --compress-level=1 is used here as testing shows on fast network it's enough compression while at default level (6) we are already bound by the cpu
# on slow connections it might still be worth to use --compress-level=6 which could save around 40% of the bandwith
drush -y rsync --mode=akzi --compress-level=1 $SOURCE:$SYNCDIR $SYNCDIR
# Delete the exported sql files from the source for security.
drush $SOURCE ssh "rm -rf $SYNCDIR"
drush -y rsync --mode=akzi --compress-level=1 $SYNCDIR $TARGET:$SYNCDIR
# Delete the exported sql files from the local machine for security.
rm -rf $SYNCDIR

# Let's not use -y here yet so that we have at least one confirmation in this
# script before we destroy the $TARGET data.
drush $TARGET sql-drop
drush $TARGET importdb --dump-dir=$SYNCDIR

# Delete the exported sql files from target for security.
drush $TARGET ssh "rm -rf $SYNCDIR"

# Include any project specific sync commands.
if [ -f syncdb_local.sh ]
then
  source syncdb_local.sh
fi

# Clear caches after sync.
drush $TARGET cache-clear all
