#!/usr/bin/env bash

# Continue by truncating personal information like social security numbers.
drush $TARGET sqlq "UPDATE field_data_field_social SET field_social_value = ''"
drush $TARGET sqlq "UPDATE field_revision_field_social SET field_social_value = ''"
echo 'Truncated personal information, including SSN...'
