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

if [[ $1 == 'up' || $1 == 'provision' ]]; then
  path="`pwd`"

  eval $(parse_yaml conf/project.yml)
  if [ ! -d "ansible/playbook" ]; then
    git clone  -b $ansible_branch $ansible_remote ansible/playbook 
    if [ -n "$ansible_revision" ]; then
      cd ansible/playbook
      #git reset --hard $ANSIBLE_revision
      cd $path
    fi
  else
    if [ -z "$ansible_revision" ]; then
      cd ansible/playbook
      git pull
      cd $path
    fi
  fi
  if [ -n "$buildsh_revision" ]; then
    curl -o drupal/build.sh https://raw.githubusercontent.com/tcmug/build.sh/$buildsh_revision/build.sh
  else
    curl -o drupal/build.sh https://raw.githubusercontent.com/tcmug/build.sh/$buildsh_branch/build.sh
  fi
fi

