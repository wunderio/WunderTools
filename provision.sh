#!/bin/bash
ENVIRONMENT=$1

pushd `dirname $0` > /dev/null
ROOT=`pwd -P`
popd > /dev/null

PLAYBOOKTARGET=$ROOT/ansible/playbook/$ENVIRONMENT.yml
PLAYBOOKPATH=$ROOT/conf/$ENVIRONMENT.yml
INVENTORY=$ROOT/conf/hosts
EXTRA_VARS=$ROOT/conf/variables.yml

if [ ! -h $PLAYBOOKTARGET ]; then
  ln -s $PLAYBOOKPATH $PLAYBOOKTARGET
fi

ansible-playbook $PLAYBOOKTARGET -c ssh -i $INVENTORY -e $EXTRA_VARS --ask-sudo-pass --ask-vault-pass
