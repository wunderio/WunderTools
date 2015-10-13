#!/bin/bash
# Helper function to parse yaml configs
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

SCRIPT=$(readlink -f $0)
ROOT=`dirname $SCRIPT`
# Parse project config
PROJECTCONF=$ROOT/conf/project.yml
eval $(parse_yaml $PROJECTCONF)
ALIASFILE=${project_name}.aliases.drushrc.php
ALIASPATH=$ROOT/drupal/conf/$ALIASFILE
ALIASTARGET=$HOME/.drush/$ALIASFILE

if [[ $1 == "reset" ]]; then
  read -p "This will reset everything! Are you sure?" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd $PATH
    vagrant destroy
    rm -r $PATH/ansible
    rm $ALIASTARGET
  fi
# Only run when running vagrant up or provision
elif [[ $1 == "up" || $1 == "provision" ]]; then
  # First we check if there is update for this script
  SELF=$(basename $0)
  UPDATEURL="https://raw.githubusercontent.com/wunderkraut/Ansibleref/master/build.sh"
  MD5SELF=$(md5sum $0 | awk '{print $1}')
  MD5LATEST=$(curl -s $UPDATEURL | md5sum | awk '{print $1}')
  if [[ "$MD5SELF" != "$MD5LATEST" ]]; then
    read -p "There is update for this script available. Update now?" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      cd $ROOT
      curl -o $SELF $UPDATEURL
      echo "Update complete, please rerun any command you were running previously."
      echo "Also remember to add updated script to git."
      exit
    fi
  fi
  # Clone and update virtual environment configurations
  if [ ! -d "ansible" ]; then
    git clone  -b $ansible_branch $ansible_remote ansible
    if [ -n "$ansible_revision" ]; then
      cd ansible
      git reset --hard $ANSIBLE_revision
      cd $ROOT
    fi
  else
    if [ -z "$ansible_revision" ]; then
      cd ansible
      git pull
      cd $ROOT
    fi
  fi

  # Get & update drupal/build.sh
  if [ -n "$buildsh_revision" ]; then
    curl -o drupal/build.sh https://raw.githubusercontent.com/wunderkraut/build.sh/$buildsh_revision/build.sh
  else
    curl -o drupal/build.sh https://raw.githubusercontent.com/wunderkraut/build.sh/$buildsh_branch/build.sh
  fi

  # Ensure drush aliases file is linked
  if [ ! -h $ALIASTARGET ] || [ ! "$(readlink $ALIASTARGET)" -ef "$ALIASPATH" ]; then
    rm $ALIASTARGET
    ln -s $ALIASPATH $ALIASTARGET
  fi
fi

