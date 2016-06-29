#!/bin/bash

VAULT_FILE=$WT_ANSIBLE_VAULT_FILE
MYSQL_ROOT_PASS=

show_help() {
cat <<EOF
Usage: ${0##*/} [-fm MYSQL_ROOT_PASS] [-t|s ANSIBLE_TAGS] [-v ANSIBLE_VAULT_FILE] [ENVIRONMENT] 
      -f                    First run, use when provisioning new servers.
      -m MYSQL_ROOT_PASS    For first run you need to provide new mysql root password.
      -v ANSIBLE_VAULT_FILE Path to ansible vault password. This can also be provided with WT_ANSIBLE_VAULT_FILE environment variable.
      -t ANSIBLE_TAGS       Ansible tags to be provisioned.
      -s ANSIBLE_TAGS       Ansible tags to be skipped when provisioning.
         ENVIRONMENT        Environment to be provisioned.
EOF

}
OPTIND=1
ANSIBLE_TAGS=""

while getopts "hfv:m:t:s:" opt; do
    case "$opt" in
    h)
        show_help
        exit 0
        ;;
    v)  VAULT_FILE=$OPTARG
        ;;
    f)  FIRST_RUN=1
        ;;
    m)  MYSQL_ROOT_PASS=$OPTARG
        ;;
    t)  ANSIBLE_TAGS=$OPTARG
        ;;
    s)  ANSIBLE_SKIP_TAGS=$OPTARG
        ;;
    esac
done

shift "$((OPTIND-1))"
ENVIRONMENT=$1

if [ -z $ENVIRONMENT ]; then
  show_help
  exit 1
fi

if [ -z $VAULT_FILE ]; then
  echo "Vault password file missing."
  echo "You can provide the path to the file with -v option."
  echo "Alternatively you can set WT_ANSIBLE_VAULT_FILE environment variable."
  exit 1
fi

pushd `dirname $0` > /dev/null
ROOT=`pwd -P`
popd > /dev/null

PLAYBOOKPATH=$ROOT/conf/$ENVIRONMENT.yml
INVENTORY=$ROOT/conf/server.inventory
EXTRA_VARS=$ROOT/conf/variables.yml

if [ $FIRST_RUN ]; then
  if [ -z $MYSQL_ROOT_PASS ]; then
    echo "Mysql root password missing. You need to provide password using -m flag."
    exit 1
  else
    ansible-playbook $PLAYBOOKPATH -c ssh -i $INVENTORY -e "@$EXTRA_VARS"  -e "change_db_root_password=True mariadb_root_password=$MYSQL_ROOT_PASS" --ask-pass --vault-password-file=$VAULT_FILE $ANSIBLE_TAGS
  fi
else
  if [ $ANSIBLE_TAGS ]; then
    ansible-playbook $PLAYBOOKPATH -c ssh -i $INVENTORY -e $EXTRA_VARS --vault-password-file=$VAULT_FILE --tags "$ANSIBLE_TAGS"
  elif [ $ANSIBLE_SKIP_TAGS ]; then
    ansible-playbook $PLAYBOOKPATH -c ssh -i $INVENTORY -e $EXTRA_VARS --vault-password-file=$VAULT_FILE --skip-tags "$ANSIBLE_SKIP_TAGS"
  else
    ansible-playbook $PLAYBOOKPATH -c ssh -i $INVENTORY -e $EXTRA_VARS --vault-password-file=$VAULT_FILE
  fi
fi
