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

# Cache by default.
RELOAD=false
# Don't revert features by default.
FRA=false

# Get config from flags. We are doing this here so that flags override project
# config.
#
# Use -gt 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use -gt 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --help example).
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -n|--name)
    project_name="$2"
    shift # Past argument
    ;;
    -s|--source)
    SOURCE="$2"
    shift # Past argument
    ;;
    -t|--target)
    TARGET="$2"
    shift # Past argument
    ;;
    -f|--file-sync-url)
    project_file_sync_url="$2"
    shift # Past argument
    ;;
    -r|--reload-cache)
    RELOAD=true
    shift # Past argument
    ;;
    -fra|--features-revert-all)
    FRA=true
    shift # Past argument
    ;;
    -h|--help)
    echo "Usage: ./syncdb.sh [options]
Example: ./syncdb.sh -n example1 -s prod -t local -f https://www.example1.com
Options:
  -n PROJECT_NAME, --name PROJECT_NAME  Specify the project name used as Drush
                                        aliases prefix. Defaults to
                                        'project: name' in 'conf/project.yml'.
  -s SOURCE, --source SOURCE            Specify the source environment for
                                        the sync. Defaults to 'prod'. Needs to
                                        match a Drush alias name.
  -t TARGET, --target TARGET            Specify the target environment for
                                        the sync. Defaults to 'local'. Needs to
                                        match a Drush alias name.
  -f URL, --file-sync-url URL           Specify the URL of the environment used
                                        for file sync for example with
                                        Stage File Proxy module. Defaults to
                                        the SOURCE URI, but can also be set
                                        globally by 'project: file_sync_url' in
                                        'conf/project.yml'.
  -r, --reload-cache                    Database is cached in the target
                                        environment by default. Use this flag
                                        to sync a fresh database.
  -fra, --features-revert-all           Revert features as part of the sync.
                                        Defaults to false.
  -h, --help                            Print this help.
"
    exit
    ;;
    *)
      # Unknown option
    ;;
esac
shift # Past argument or value
done

# Make sure we have the $project_name
if [ -z "$project_name" ]; then
  echo "Project name missing. Set in 'conf/project.yml' or use -p flag. Use -h for more help."
  exit
fi

# Default $SOURCE to "prod".
if [ -z "$SOURCE" ]; then
  echo "Source defaults to 'prod'. Change with -s flag. Use -h to see all options."
  SOURCE="@$project_name.prod"
else
  SOURCE="@$project_name.$SOURCE"
fi

# Default $TARGET to "local". Prevent "prod" and "production".
if [ -z "$TARGET" ]; then
  echo "Target defaults to 'local'. Change with -t flag. Use -h to see all options."
  TARGET="@$project_name.local"
else
  if [[ $TARGET == *"prod"* ]]; then
    echo "You tried to sync to a production environment!"
    echo "This is probably never the intention, so we always fail such attempts."
    exit
  else
    TARGET="@$project_name.$TARGET"
  fi
fi

# Get the project_file_sync_url to use from SOURCE URI. This requires the URI to
# be in full format including the protocol to use like HTTPS. Only get it if not
# specified in a flag or in project config.
if [ -z "$project_file_sync_url" ]; then
  project_file_sync_url=$(drush $SOURCE status | awk 'NR==2{print $4}')
fi

# Use the project directory for syncing.
SYNCTARGETBASE="`drush $TARGET ssh "cd ../ && pwd"`"

# Check if we have cache.
CACHE="`drush $TARGET ssh "[ -f ../SYNCDIR ] && cat ../SYNCDIR || echo false"`"
# Sync the database.
if [ $CACHE = false ] || [ "$RELOAD" = true ]; then
  # Make sure we clean up.
  if [ ! $CACHE = false ]; then
    CLEANUPDIR="$SYNCTARGETBASE/$CACHE"
  fi
  # Set sync directory with timestamp to allow parallel syncing.
  SYNCDIR="syncdb/$project_name$(date +%s)"
  # Use the project directory for syncing.
  SYNCSOURCE="`drush $SOURCE ssh "cd ../ && pwd"`/$SYNCDIR"
  SYNCTARGET="$SYNCTARGETBASE/$SYNCDIR"
  SYNCLOCAL="$ROOT/drupal/$SYNCDIR"
  # Store the sync dir to use for caching.
  drush $TARGET ssh "echo "$SYNCDIR" > ../SYNCDIR"
  echo "Using directory $SYNCDIR for syncing."
  if [ "$RELOAD" = false ]; then
    echo "Database will be cached on the target. Use -r flag to reload cache."
  fi
  # Get the dump from source.
  drush $SOURCE dumpdb --structure-tables-list=cache,cache_*,history,sessions,watchdog --dump-dir=$SYNCSOURCE
  # Make sure the sync folder exists on the machine where this script is run so that rsync will not fail.
  mkdir -p $SYNCLOCAL
  # --compress-level=1 is used here as testing shows on fast network it's enough compression while at default level (6) we are already bound by the cpu
  # on slow connections it might still be worth to use --compress-level=6 which could save around 40% of the bandwith
  drush -y rsync --mode=akzi --compress-level=1 $SOURCE:$SYNCSOURCE $SYNCLOCAL
  # Delete the exported sql files from the source for security.
  drush $SOURCE ssh "rm -rf $SYNCSOURCE"
  # Locally we don't need the to sync to target because the project folder is
  # already shared.
  if [[ ! $TARGET == *"local"* ]]; then
    # Make sure the tmp folder is created in the target machine.
    drush $TARGET ssh "mkdir -p $SYNCTARGET"
    # Sync to target.
    drush -y rsync --mode=akzi --compress-level=1 $SYNCLOCAL $TARGET:$SYNCTARGET
    # Delete the exported sql files from the local machine for security.
    rm -rf $SYNCLOCAL
  fi
else
  # Use cache by default.
  SYNCTARGET="$SYNCTARGETBASE/$CACHE"
  # Make sure we actually have cache.
  CACHECONFIRMED="`drush $TARGET ssh "[ -d $SYNCTARGET ] && echo true || echo false"`"
  if [ $CACHECONFIRMED = false ]; then
    echo "Cache $SYNCTARGET not found. Use -r flag to reload.
Aborting..."
    exit
  fi
  echo "Using cached database in directory $CACHE for syncing."
fi

echo "Finalise sync to $TARGET and drop all existing data?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) DROP=true; break;;
        No ) DROP=false; break;;
    esac
done

if [ $DROP = true ]; then
  # Make sure we start clean.
  drush $TARGET sql-drop -y
  # Import the database to target.
  drush $TARGET importdb --dump-dir=$SYNCTARGET
  # Include any project specific sync commands.
  if [ -f syncdb_local.sh ]
  then
    source syncdb_local.sh
  fi
  # Revert features when asked.
  if [ $FRA = true ]; then
    drush $TARGET fra -y
  fi
  # Clear caches after sync.
  drush $TARGET cache-clear all
fi

# Delete the exported sql files from target for security when new files are
# fetched and cached.
if [ -z "$CLEANUPDIR" ]; then
  drush $TARGET ssh "rm -rf $CLEANUPDIR"
fi

# Dump the processed database on target to cache.
if [ $CACHE = false ]; then
  drush $TARGET dumpdb --structure-tables-list=cache,cache_*,history,sessions,watchdog --dump-dir=$SYNCTARGET
fi
