#!/usr/bin/env bash

# Special sanitise of users to retain the test accounts.

## Helper function for printing out the list of test account IDs.
function join_by { local IFS="$1"; shift; echo "$*"; }

## Specify the accounts by ID to retain.
if [ $project_name == 'wundertools' ]; && [ $TARGET != 'local' ] then

  ACCOUNTS[2]=2
  ACCOUNTS[3]=3
  ACCOUNTS[5]=5

  # Create comma separated list of accounts.
  ACCOUNTS=$(join_by , "${ACCOUNTS[@]}")

else
  ACCOUNTS="0"
fi

## Run the sanitation.
drush $TARGET sql-query "UPDATE users SET mail = CONCAT('user', uid, '@local') WHERE name != 'admin' AND uid not in($ACCOUNTS)"
drush $TARGET sql-query "UPDATE users SET init = '' WHERE name != 'admin' AND uid not in($ACCOUNTS)"
drush $TARGET sql-query "UPDATE users SET pass = '' WHERE name != 'admin' AND uid not in($ACCOUNTS)"
ADMIN=$(drush $TARGET uinf 1 --fields=name)
drush $TARGET upwd $ADMIN --password=admin
echo 'Sanitized users, emails and database.'

# Enable Stage File Proxy.
drush $TARGET pm-enable --yes stage_file_proxy
drush $TARGET variable-set stage_file_proxy_origin "$project_file_sync_url"
echo 'Enabled Stage File Proxy.'

# Run any pending updates
drush $TARGET updb -y

# Revert features because there is usually new ones in the environment where we
# sync to.
drush $TARGET fra -y
