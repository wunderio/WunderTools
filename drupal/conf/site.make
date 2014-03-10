; Drush Make File
; ----------------

projects[drupal][type] = core
projects[drupal][version] = 7.26
core = 7.0
api = 2

projects[ctools][version] = 1.3
projects[ctools][subdir] = contrib

projects[views][version] = 3.7
projects[views][subdir] = contrib

projects[entity][version] = 1.2
projects[entity][subdir] = contrib

projects[rules][version] = 2.6
projects[rules][subdir] = contrib

projects[redis][version] = 2.6
projects[redis][subdir] = contrib
projects[redis][patch][redis-sockets] = "http://drupal.org/files/redis-RedisPHP-sockets-1528912-11.patch"
projects[redis][patch][clear-all] = "http://drupal.org/files/issues/cache_clear_all-2140897-1.patch"

projects[varnish][version] = 1.0-beta2
projects[varnish][subdir] = contrib

