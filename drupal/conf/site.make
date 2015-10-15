; Drush Make File
; ----------------

core = 7.0
api = 2

projects[drupal][type] = core
projects[drupal][version] = 7.40

defaults[projects][subdir] = "contrib"

; Contrib
; ----------------

projects[admin_views][version] = 1.5
projects[coffee][version] = 2.2
projects[ctools][version] = 1.9
projects[devel][version] = 1.5
projects[entity][version] = 1.6
projects[entity_translation][version] = 1.0-beta4
projects[memcache][version] = 1.5
projects[pathologic][version] = 2.12
projects[rules][version] = 2.9
projects[search_api][version] = 1.14
projects[search_api_solr][version] = 1.6
projects[varnish][version] = 1.0-beta3
projects[views][version] = 3.11
projects[views_bulk_operations][version] = 3.3
projects[webform][version] = 4.7

projects[language_hierarchy][download][revision] = b7d59dd873f2159d38a258a60ff26fa900060be7
projects[language_hierarchy][download][branch] = 7.x-1.x
projects[language_hierarchy][patch][] = https://www.drupal.org/files/issues/entity-translation-hierarchy-submodule-not-compatible-with-entity-translation-7.x-1.0-beta4-2450929-4.patch
projects[language_hierarchy][patch][] = https://www.drupal.org/files/issues/incompatibility-drupal-7.36-javascript-2474365-1.patch
