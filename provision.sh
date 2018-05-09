#!/bin/bash

VAULT_FILE=$WT_ANSIBLE_VAULT_FILE
MYSQL_ROOT_PASS=

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


show_help() {
cat <<EOF
Usage: ${0##*/} [-fm MYSQL_ROOT_PASS] [-t|s ANSIBLE_TAGS] [-p ANSIBLE_VAULT_FILE] [ENVIRONMENT] 
      -f                    First run, use when provisioning new servers.
      -r                    Skip installing requirements from ansible/requirements.txt.
      -m MYSQL_ROOT_PASS    For first run you need to provide new mysql root password.
      -p ANSIBLE_VAULT_FILE Path to ansible vault password. This can also be provided with WT_ANSIBLE_VAULT_FILE environment variable.
      -t ANSIBLE_TAGS       Ansible tags to be provisioned.
      -s ANSIBLE_TAGS       Ansible tags to be skipped when provisioning.
         ENVIRONMENT        Environment to be provisioned.
EOF

}
self_update() {
  if command -v md5sum >/dev/null 2>&1; then
    MD5COMMAND="md5sum"
  else
    MD5COMMAND="md5 -r"
  fi

  SELF=$(basename $0)
  UPDATEURL="https://raw.githubusercontent.com/wunderio/WunderTools/$GITBRANCH/provision.sh"
  MD5SELF=$($MD5COMMAND $0 | awk '{print $1}')
  MD5LATEST=$(curl -s $UPDATEURL | $MD5COMMAND | awk '{print $1}')
  if [[ "$MD5SELF" != "$MD5LATEST" ]]; then
    read -p "There is update for this script available. Update now ([y]es / [n]o)?" -n 1 -r;
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      cd $ROOT
      curl -s -o $SELF $UPDATEURL
      echo "Update complete, please rerun any command you were running previously."
      echo "See CHANGELOG for more info."
      echo "Also remember to add updated script to git."
      exit
    fi
  fi
  # Clone and update virtual environment configurations
  if [ ! -d "$ROOT/ansible" ]; then
    git clone  -b $ansible_branch $ansible_remote $ROOT/ansible
    if [ -n "$ansible_revision" ]; then
      cd $ROOT/ansible
      git reset --hard $ansible_revision
      cd $ROOT
    fi
  else
    if [ -z "$ansible_revision" ]; then
      cd $ROOT/ansible
      git pull
      git checkout $ansible_branch
      cd $ROOT
    fi
  fi

  # Use secrets if it's defined in conf/project.yml
  # Do this for everything else than local vagrant provisioning
  if [ "$ENVIRONMENT" != "vagrant" ] && [ "$wundersecrets_remote" != "" ]; then
    # Set defaults for WunderSecrets
    export wundersecrets_branch=${wundersecrets_branch-master}

    # Clone and update virtual environment secrets
    if [ ! -d "$wundersecrets_path" ]; then
      git clone  -b $wundersecrets_branch $wundersecrets_remote $wundersecrets_path
      if [ -n "$wundersecrets_revision" ]; then
        git -C "$wundersecrets_path" reset --hard $wundersecrets_revision
      fi
    else
      if [ -z "$wundersecrets_revision" ]; then
        git -C "$wundersecrets_path" pull
        git -C "$wundersecrets_path" checkout $wundersecrets_branch
      fi
    fi
  fi
}
pushd `dirname $0` > /dev/null
ROOT=`pwd -P`
popd > /dev/null
# Parse project config
PROJECTCONF=$ROOT/conf/project.yml
echo $PROJECTCONF
eval $(parse_yaml $PROJECTCONF)

if [ -z "$wundertools_branch" ]; then
  GITBRANCH="master"
else
  GITBRANCH=$wundertools_branch
fi

export wundersecrets_path=$ROOT/secrets

self_update

OPTIND=1
ANSIBLE_TAGS=""
EXTRA_OPTS=""

while getopts ":hfrp:m:t:s:" opt; do
    case "$opt" in
    h)
        show_help
        exit 0
        ;;
    p)  VAULT_FILE=$OPTARG
        ;;
    f)  FIRST_RUN=1
        ;;
    r)  SKIP_REQUIREMENTS=1
        ;;
    m)  MYSQL_ROOT_PASS=$OPTARG
        ;;
    t)  ANSIBLE_TAGS=$OPTARG
        ;;
    s)  ANSIBLE_SKIP_TAGS=$OPTARG
        ;;
    *)  EXTRA_OPTS="$EXTRA_OPTS -$OPTARG"
    esac
done

shift "$((OPTIND-1))"
ENVIRONMENT=$1

if [ -z $ENVIRONMENT ]; then
  show_help
  exit 1
fi

if [ -z $VAULT_FILE ]; then
  echo -e "\e[31mVault password file missing.\e[0m"
  echo -e "You can provide the path to the file with -p option."
  echo -e "Alternatively you can set WT_ANSIBLE_VAULT_FILE environment variable."
  echo -e "If you don't have any ansible-vault encrypted config file this is just fine,"
  echo -e "Otherwise your provisioning will fail horribly.\e[31mYou have been warned!\e[0m"
fi

pushd `dirname $0` > /dev/null
ROOT=`pwd -P`
popd > /dev/null

PLAYBOOKPATH=$ROOT/conf/$ENVIRONMENT.yml
if [ "$ENVIRONMENT" == "vagrant" ]; then
  INVENTORY=$ROOT/ansible/inventory.py
  VAGRANT_CREDENTIALS="--private-key=.vagrant/machines/default/virtualbox/private_key -u vagrant -e 'host_key_checking=False'"
else
  INVENTORY=$ROOT/conf/server.inventory
fi
EXTRA_VARS=$ROOT/conf/variables.yml

if [ ! $SKIP_REQUIREMENTS ] ; then
  # Check if pip is installed
  which -a pip >> /dev/null
  if [[ $? != 0 ]] ; then
      echo "ERROR: pip is not installed! Install it first."
      echo "OSX:    $ easy_install pip"
      echo "Ubuntu: $ sudo apt-get install python-setuptools python-dev build-essential && sudo easy_install pip"
      echo "Centos: $ yum -y install python-pip"
      exit 1
  else
    # Install virtualenv
    which -a pipenv >> /dev/null
    if [[ $? != 0 ]] ; then
      sudo pip install pipenv
    fi
    cd $ROOT/ansible
    VENV=`pipenv --venv`

    # Ensure ansible & ansible library versions with pip
    if [ -f $ROOT/ansible/Pipfile.lock ]; then
      pipenv install 
    else
      pipenv install ansible
    fi
  fi
fi

# Install ansible-galaxy roles
if [ -f $ROOT/conf/requirements.yml ]; then
  pipenv run ansible-galaxy install -r $ROOT/conf/requirements.yml
fi

# Setup&Use WunderSecrets if the additional config file exists
if [ -f $wundersecrets_path/ansible.yml ]; then
  WUNDER_SECRETS="--extra-vars=@$wundersecrets_path/ansible.yml"
else
  WUNDER_SECRETS=""
fi

# Use vault encrypted file from WunderSecrets when available
if [ "$VAULT_FILE" != "" ] && [ -f $wundersecrets_path/vault.yml ]; then
  WUNDER_SECRETS="$WUNDER_SECRETS --extra-vars=@$wundersecrets_path/vault.yml"
fi

if [ $FIRST_RUN ]; then
  if [ -z $MYSQL_ROOT_PASS ]; then
    pipenv run ansible-playbook $EXTRA_OPTS $PLAYBOOKPATH $WUNDER_SECRETS -c ssh -i $INVENTORY -e "@$EXTRA_VARS"  -e "first_run=True" --vault-password-file=$VAULT_FILE $ANSIBLE_TAGS
  else
    pipenv run ansible-playbook $EXTRA_OPTS $PLAYBOOKPATH $WUNDER_SECRETS -c ssh -i $INVENTORY -e "@$EXTRA_VARS"  -e "change_db_root_password=True mariadb_root_password=$MYSQL_ROOT_PASS first_run=True" --vault-password-file=$VAULT_FILE $ANSIBLE_TAGS
  fi
else
  if [ $ANSIBLE_TAGS ]; then
    pipenv run ansible-playbook $EXTRA_OPTS $VAGRANT_CREDENTIALS $PLAYBOOKPATH $WUNDER_SECRETS -c ssh -i $INVENTORY -e "@$EXTRA_VARS" --vault-password-file=$VAULT_FILE --tags "common,$ANSIBLE_TAGS"
  elif [ $ANSIBLE_SKIP_TAGS ]; then
    pipenv run ansible-playbook $EXTRA_OPTS $VAGRANT_CREDENTIALS $PLAYBOOKPATH $WUNDER_SECRETS -c ssh -i $INVENTORY -e "@$EXTRA_VARS" --vault-password-file=$VAULT_FILE --skip-tags "$ANSIBLE_SKIP_TAGS"
  else
   pipenv run ansible-playbook $EXTRA_OPTS $VAGRANT_CREDENTIALS $PLAYBOOKPATH $WUNDER_SECRETS -c ssh -i $INVENTORY -e "@$EXTRA_VARS" --vault-password-file=$VAULT_FILE
  fi
fi
