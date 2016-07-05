; Drush Make File
; ----------------

core = 7.0
api = 2

projects[drupal][type] = core
projects[drupal][version] = 7.44

defaults[projects][subdir] = "contrib"

; Contrib
; ----------------

; Basics
; --------------------
projects[ctools][version] = 1.9
projects[elysia_cron][version] = 2.1
projects[entity][version] = 1.6
projects[entity_translation][version] = 1.0-beta4
projects[features][version] = 2.0
projects[imagemagick][version] = 1.0
projects[libraries][version] = 2.2
projects[views_litepager][version] = 3.0
projects[memcache][version] = 1.5
projects[metatag][version] = 1.5
projects[pathauto][version] = 1.2
projects[rules][version] = 2.9
projects[search_api][version] = 1.14
projects[search_api_solr][version] = 1.6
projects[strongarm][version] = 2.0
projects[token][version] = 1.6
projects[varnish][version] = 1.0-beta3
projects[views][version] = 3.11

; Admin
; --------------------

projects[admin_language][version] = 1.0-beta1
projects[admin_views][version] = 1.5
projects[fpa][version] = 2.5
projects[module_filter][version] = 2.0

projects[navbar][version] = 1.6
; Fix scrolling issues
projects[navbar][patch][] = "https://drupal.org/files/issues/navbar-2183753-10-ie-navbar-issue.patch"

projects[simplei][version] = 1.0
projects[simplei][patch][] = http://www.drupal.org/files/issues/2420513-support-for-navbar_1.patch

projects[views_bulk_operations][version] = 3.3

; Misc improvements & tweaks
; --------------------

projects[chosen][version] = 2.0-beta4
projects[chosen][patch][] = 'https://www.drupal.org/files/issues/chosen-toggle-admin-pages-option-2534756-5.patch'

projects[media][version] = 2.0-alpha3

projects[pathologic][version] = 2.12

projects[wysiwyg][type] = "module"
projects[wysiwyg][download][type] = "git"
projects[wysiwyg][download][url] = "http://git.drupal.org/project/wysiwyg.git"
projects[wysiwyg][download][revision] = "d9c3f6559046ff9790d8ba8589653d0646e2baae"
projects[wysiwyg][patch][507696][url] = "http://www.drupal.org/files/wysiwyg_field_size_507696_96_0.patch"

; Libraries
; --------------------

libraries[backbone][download][type] = "get"
libraries[backbone][type] = "libraries"
libraries[backbone][download][url] = "https://github.com/jashkenas/backbone/archive/1.1.0.tar.gz"

libraries[ckeditor][download][type] = "get"
libraries[ckeditor][type] = "libraries"
libraries[ckeditor][download][url] = "http://download.cksource.com/CKEditor/CKEditor/CKEditor%204.4.2/ckeditor_4.4.2_standard.zip"

libraries[chosen][download][type] = "get"
libraries[chosen][type] = "libraries"
libraries[chosen][download][url] = "https://github.com/harvesthq/chosen/releases/download/1.4.2/chosen_v1.4.2.zip"

libraries[modernizr][download][type] = "get"
libraries[modernizr][type] = "libraries"
libraries[modernizr][download][url] = "https://github.com/Modernizr/Modernizr/archive/v2.7.1.tar.gz"

libraries[underscore][download][type] = "get"
libraries[underscore][type] = "libraries"
libraries[underscore][download][url] = "https://github.com/jashkenas/underscore/archive/1.5.2.zip"


