#!/usr/bin/env bash

# Sanitise the database.

## Run the sanitation.
drush $TARGET sqlsan -y

# Enable Stage File Proxy.
drush $TARGET pm-enable --yes stage_file_proxy
# @TODO: There is no variable-set in D8.
# drush $TARGET variable-set stage_file_proxy_origin "$project_file_sync_url"
echo 'Enabled Stage File Proxy.'

# Run any pending updates.
drush $TARGET updb -y

# @TODO: Add config import.
