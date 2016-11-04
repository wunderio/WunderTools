#!/bin/sh
# This file will sync local development environment with the dev server
# SQL from the server + rsync.

drush sql-sync @site.stage @site.local --structure-tables-list=cache,cache_*,history,search_*,sessions,watchdog --sanitize
echo 'SQL sync ready.';

drush rsync @site.stage:%files/ drupal/files/
echo 'RSync ready.';

# Set UID1 password to 'root'
#drush @site.local sqlq "UPDATE users SET name = 'root' WHERE name = 'admin'"
drush @site.local sqlq "UPDATE users_field_data SET mail = 'user@example.com' WHERE name != 'admin'"
drush @site.local sqlq "UPDATE users_field_data SET init = '' WHERE name != 'admin'"
drush @site.local sqlq "UPDATE users_field_data SET pass = '' WHERE name != 'admin'"
drush @site.local upwd admin --password=admin
echo 'Truncated emails and passwords from the database.';

# Download Devel
# drush @site.local dl devel -y;

# Download maillog to prevent emails being sent
#drush @site.local dl maillog -y;

# Set maillog default development environment settings
#drush @site.local vset maillog_devel 1;
#drush @site.local vset maillog_log 1;
#drush @site.local vset maillog_send 0;

# Enable Devel and UI modules
# drush @site.local en field_ui devel views_ui context_ui feeds_ui rules_admin dblog --yes;
# echo 'Enabled Devel and Views+Context+Feeds+Rules UI modules.';

# Disable google analytics
# drush @site.local dis googleanalytics --yes;
# echo 'Disabled Google Analytics.';

# Set site email address to admin@example.com
#drush @site.local vset site_mail "admin@example.com"

# Set imagemagick convert path
# drush @site.local vset imagemagick_convert "/opt/local/bin/convert"

#Enable stage file proxy
drush @site.local pm-download stage_file_proxy;
drush @site.local pm-enable --yes stage_file_proxy;
drush @site.local cset --yes stage_file_proxy.settings origin "https://wundertools.site"
echo "Enabled stage file proxy so you won't need the files locally, jeee!"


# Clear caches
drush @site.local cr all;

# FINISH HIM
#say --voice=Zarvox "Sync is now fully completed."
