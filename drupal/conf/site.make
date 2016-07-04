; Drush Make File
; ----------------

core = 7.0
api = 2

projects[drupal][type] = core
projects[drupal][version] = 7.44

defaults[projects][subdir] = contrib

; Contrib
; ----------------

; Basics
; --------------------
projects[ctools][version] = 1.9
projects[elysia_cron][version] = 2.1
projects[entity][version] = 1.7
projects[entity_translation][version] = 1.0-beta5
projects[features][version] = 2.10
projects[imagemagick][version] = 1.0
projects[libraries][version] = 2.3
projects[views_litepager][version] = 3.0
projects[memcache][version] = 1.5
projects[metatag][version] = 1.17
projects[pathauto][version] = 1.3
projects[rules][version] = 2.9
projects[search_api][version] = 1.18
projects[search_api_solr][version] = 1.10
projects[strongarm][version] = 2.0
projects[token][version] = 1.6
projects[varnish][version] = 1.1
projects[views][version] = 3.14

; Admin
; --------------------

projects[admin_language][version] = 1.0-beta1
projects[admin_views][version] = 1.5
projects[fpa][version] = 2.6
projects[module_filter][version] = 2.0

projects[navbar][version] = 1.7

projects[simplei][version] = 1.0
projects[simplei][patch][2420513] = https://www.drupal.org/files/issues/2420513-support-for-navbar_1.patch

projects[views_bulk_operations][version] = 3.3

; Misc improvements & tweaks
; --------------------

projects[chosen][version] = 2.0-beta5
projects[chosen][patch][2534756] = https://www.drupal.org/files/issues/chosen-toggle-admin-pages-option-2534756-5.patch

; projects[ckeditor][type] = module
; projects[ckeditor][download][type] = git
; projects[ckeditor][download][url] = https://git.drupal.org/project/ckeditor.git
; projects[ckeditor][download][revision] = 3657990d71eba79225f01df860adaab84e66f554

projects[media][version] = 2.0-beta2

projects[pathologic][version] = 3.1

projects[wysiwyg][type] = module
projects[wysiwyg][download][type] = git
projects[wysiwyg][download][url] = http://git.drupal.org/project/wysiwyg.git
projects[wysiwyg][download][revision] = 18deb5ab9cc5255822a7d336891d043d35e660d2

; Libraries
; --------------------

libraries[backbone][download][type] = get
libraries[backbone][type] = libraries
libraries[backbone][download][url] = https://github.com/jashkenas/backbone/archive/1.3.3.tar.gz

libraries[ckeditor][download][type] = get
libraries[ckeditor][type] = libraries
libraries[ckeditor][download][url] = http://download.cksource.com/CKEditor/CKEditor/CKEditor%204.5.9/ckeditor_4.5.9_standard.zip

libraries[chosen][download][type] = get
libraries[chosen][type] = libraries
libraries[chosen][download][url] = https://github.com/harvesthq/chosen/releases/download/v1.6.1/chosen_v1.6.1.zip

libraries[modernizr][download][type] = get
libraries[modernizr][type] = libraries
libraries[modernizr][download][url] = https://github.com/Modernizr/Modernizr/archive/v2.8.3.tar.gz

libraries[underscore][download][type] = get
libraries[underscore][type] = libraries
libraries[underscore][download][url] = https://github.com/jashkenas/underscore/archive/1.8.3.tar.gz
