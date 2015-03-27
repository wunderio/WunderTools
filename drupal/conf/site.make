; Drush Make File
; ----------------

core = 7.0
api = 2

projects[drupal][type] = core
projects[drupal][version] = 7.35

; PATCH: user_save might on occasion delete images from users
projects[drupal][patch][935592] = https://www.drupal.org/files/issues/935592-89.patch

defaults[projects][subdir] = "contrib"

; Contrib
; ----------------

projects[admin_views][version] = 1.4
projects[ctools][version] = 1.7
projects[devel][version] = 1.5
projects[entity][version] = 1.6
projects[entity_translation][version] = 1.0-beta4
projects[memcache][version] = 1.5
projects[pathologic][version] = 2.12
projects[rules][version] = 2.9
projects[search_api][version] = 1.14
projects[search_api_solr][version] = 1.6
projects[varnish][version] = 1.0-beta3
projects[views][version] = 3.10
projects[views_bulk_operations][version] = 3.2
projects[webform][version] = 4.7
