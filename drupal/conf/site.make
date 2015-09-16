; Drush Make File
; ----------------

core = 8.0
api = 2


;projects[drupal][type] = core
;projects[drupal][version] = 8.0

projects[drupal][download][type] = git
projects[drupal][download][url] = http://git.drupal.org/project/drupal.git
projects[drupal][download][tag] = 8.0.0-beta15

defaults[projects][subdir] = "contrib"

; Contrib
; ----------------

