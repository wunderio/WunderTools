# Converting Drupal 7 WunderTools projects to use Composer

## Workflow

1. Install [Lando](https://docs.devwithlando.io/) (and [Docker if using Linux](https://docs.devwithlando.io/installation/linux.html))
2. Copy `composer.json` from [WunderTools](https://github.com/wunderio/WunderTools/tree/drupal7/) project and use it as a base
3. Convert `.make` file into raw composerfile: `drush make-convert [project]/drupal/conf/site.make --format=composer > [project]/drupal/raw-composer.json`. If the project doesn't have a `.make` file, create one: `drush generate-makefile site.make`
4. Copy-paste project specific blocks (`require`, `patches` etc.) from the generated `raw-composer.json` to the `composer.json` copied from WunderTools
    * also make sure you don't have duplicates, for example "devel" in both require and require-dev
5. Clean up and edit composer.json to be suitable for the project
    * change the project name and description
    * depending on the project state, it might be a good idea to define strict module versions instead of just major version to prevent breaking things during the conversion
    * define needed repositories (all that say "Enter correct project name and version number")
    * define correct module version where it says "null"
    * there might be module versions that have * in them - those need to be corrected
    * [version].x format is not supported, so if there are specific revisions of a module, the version can be replaced with [version].0 for example
    * add "/web/profiles/[profile]" under "preserve-paths"
    * if a multisite, add the subsites under "preserve-paths" instead of "web/sites/default"
    * make sure you have the following:
    ```
      "conflict": {
        "drupal/core": "8.*"
      },
      "minimum-stability": "dev",
      "prefer-stable": true,
      "config": {
        "sort-packages": true,
        "secure-http": false
      },
      "autoload": {
        "classmap": [
          "scripts/composer/ScriptHandler.php"
          ]
      },
      "scripts": {
        "pre-install-cmd": [
          "DrupalProject\\composer\\ScriptHandler::checkComposerVersion"
        ],
        "pre-update-cmd": [
          "DrupalProject\\composer\\ScriptHandler::checkComposerVersion"
        ],
        "post-install-cmd": [
          "DrupalProject\\composer\\ScriptHandler::createRequiredFiles"
        ],
        "post-update-cmd": [
          "DrupalProject\\composer\\ScriptHandler::createRequiredFiles"
        ],
        "post-create-project-cmd": [
          "DrupalProject\\composer\\ScriptHandler::removeInternalFiles"
        ]
      },
      "extra": {
        "composer-exit-on-patch-failure": true,
        "installer-paths": {
          "web/": ["type:drupal-core"],
          "web/profiles/{$name}/": ["type:drupal-profile"],
          "web/sites/all/drush/{$name}/": ["type:drupal-drush"],
          "web/sites/all/libraries/{$name}/": ["type:drupal-library"],
          "web/sites/all/modules/contrib/{$name}/": ["type:drupal-module"],
          "web/sites/all/themes/contrib/{$name}/": ["type:drupal-theme"]
        },
    ```
6. Changes on [project]/drupal/conf
    * rename site.yml to something like site.yml_bak
    * copy site.yml from wundertools into [project]/drupal/conf
    * if there are project specific things in commands.yml or site.yml_bak, move them to the new site.yml
    * remove commands.yml and site.yml_bak
    * note: if you have some other files under conf, move them to correct directories.
        * for [project]/drupal/conf/sites.php needs to be moved under [project]/drupal/web/sites
        * take a look at site.yml and commands.yml
7. Build the project
    * start lando: `lando start` (note: this tries to build the project - be cautious of any errors)
8. Import database and update db
    * import db: `lando db-import [dumpname].sql`
    * run updb: `lando drush updb`


## These will be automated (remove from this documentation when done):
1. Download files from WunderTools repository. You should have the following:
    * [project]/drupal/drush/policy.drush.inc
    * [project]/drupal/scripts/composer/ScriptHandler.php
    * [project]/drupal/scripts/syncdb.sh
    * [project]/drupal/.gitignore
    * [project]/drupal/builds/.gitkeep
    * [project]/.gitignore
2. Create drush directory on drupal root and move drush aliases file there so that you have `[project]/drupal/drush/[project].aliases.drushrc.php`
3. Edit [project]/conf/project.yml
    * Add drush alias path
    ```
    drush:
      alias_path: drupal/drush
    ```
    * add wundersecrets
    ```
    wundersecrets:
      remote: git@github.com:wunderio/WunderSecrets.git
    ```
4. Make sure build.sh is of the latest version
    * WunderTools repo: https://github.com/wunderio/WunderTools
    * [project]/drupal/build.sh
5. Create [project]/drupal/web directory and sub directories so that you have:
    * [project]/drupal/web/sites/all
    * [project]/drupal/web/sites/default (not necessarily needed for multisites)
6. Move files from [project]/code to [project]/drupal/web
    * [project]/drupal/code/profiles -> [project]/drupal/web/profiles
    * [project]/drupal/code/modules -> [project]/drupal/web/sites/all/modules
    * [project]/drupal/code/themes/custom -> [project]/drupal/web/sites/all/themes/custom
    * Check that there's nothing under [project]/drupal/code and remove the directory
7. Copy settings files from WunderTools repository
    * [project]/drupal/web/sites/default/settings.lando.php
    * [project]/drupal/web/sites/default/settings.php
    * [project]/drupal/web/sites/default/settings.silta.php
    * NOTE: for multisite projects you need to put those into subsite specific directories.
    * edit the files to work with your project
8. Move patches directory to Drupal root and edit patches path on composer.json
    * structure: 
        * old: [project]/drupal/code/patches (might be something else too depending on the project)
        * new: [project]/drupal/patches
    * replace '../code/patches' with 'patches' on composer.json
9. Create .lando.yml on Drupal root
    * download the file from WunderTools repository into [project]/drupal/.lando.yml
    * make sure PHP version is supported (http://php.net/supported-versions.php)
    * for multisite, add the following:
    ```
    proxy:
      appserver_nginx:
        - domain1.lndo.site
        - domain2.lndo.site
    ```


## Possible obstacles

### Drupal module compatibility with newer PHP version
* HTML Purifier
    * http://htmlpurifier.org/releases/htmlpurifier-4.8.0.tar.gz
    * `[UnexpectedValueException]
      internal corruption of phar "/app/web/sites/all/libraries/htmlpurifier/5312b6822fe047eef6dbaac17a8ed9a5.gz" (__HALT_COMPILER(); not found)`
    * solution: update to latest version
