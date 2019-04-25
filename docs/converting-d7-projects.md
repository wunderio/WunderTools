# Converting Drupal 7 WunderTools projects to use Composer

## Workflow

1. Install [Lando](https://docs.devwithlando.io/) (and [Docker if using Linux](https://docs.devwithlando.io/installation/linux.html))
2. Copy `composer.json` from [WunderTools](https://github.com/wunderio/WunderTools/tree/drupal7/) project and use it as a base
3. Convert `.make` file into raw composerfile: `drush make-convert [project]/drupal/conf/site.make --format=composer > [project]/drupal/raw-composer.json`. If the project doesn't have a `.make` file, create one: `drush generate-makefile site.make`
4. Copy-paste project specific blocks (`require`, `patches` etc.) from the generated `raw-composer.json` to the `composer.json` copied from WunderTools
5. Clean up and edit composer.json to be suitable for the project
    * depending on the project state, it might be a good idea to define strict module versions instead of just major version to prevent breaking things during the conversion
    * define needed repositories (all that say "Enter correct project name and version number")
    * define correct module version where it says "null"
    * there might be module versions that have * in them - those need to be corrected
    * [version].x format is not supported, so if there are specific revisions of a module, the version can be replaced with [version].0 for example
    * add "/web/profiles/[profile]" under "preserve-paths"
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
6. Site.yml and commands.yml changes
    * copy site.yml from wundertools
    * if there are project specific things in commands.yml or site.yml, move them to the new site.yml
    * remove [project]/drupal/conf/commands.yml and site.yml
7. Build the project
    * start lando: `lando start`
    * build: `lando build.sh build`
8. Import database and update db
    * import db: `lando db-import [dumpname].sql`
    * run updb: `lando drush updb`


## These will be automated (remove from this documentation when done):
1. Create drush directory on drupal root and move drush aliases file there so that you have `[project]/drupal/drush/[project].aliases.drushrc.php`
2. Edit [project]/conf/project.yml
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
3. Make sure both build.sh files are of the latest versions
    * WunderTools repo: https://github.com/wunderio/WunderTools
    * [project]/build.sh
    * [project]/drupal/build.sh
4. Create lando.settings.php
    * [project]/drupal/conf/lando.settings.php
    * get the file from an existing project (Novita for example) and see that it's good for your project (compare with vagrant.settings.php etc.)
5. Move patches directory to Drupal root and edit patches path on composer.json
    * structure: 
        * old: [project]/drupal/code/patches
        * new: [project]/drupal/patches
    * replace '../code/patches' with 'patches' on composer.json
6. Create .lando.yml on Drupal root
    * you should have [project]/drupal/.lando.yml
    * get the file from an existing project and see that it's good for your project
    * make sure PHP version is supported (http://php.net/supported-versions.php)
    * make sure the syntax is compatible with the Lando version (https://docs.devwithlando.io/guides/updating-to-rc2.html)
7. Create [project]/drupal/web directory and sub directories so that you have:
    * [project]/drupal/web/sites/all
    * [project]/drupal/web/sites/default
8. Move files from [project]/code to [project]/drupal/web
    * [project]/drupal/code/profiles -> [project]/drupal/web/profiles
    * [project]/drupal/code/modules -> [project]/drupal/web/sites/all/modules
    * [project]/drupal/code/themes/custom -> [project]/drupal/web/sites/all/themes/custom
    * Check that there's nothing under [project]/drupal/code and remove the directory
9. Add files from drupal-project
    * repo: https://github.com/drupal-composer/drupal-project/tree/7.x
    * you should have:
        * [project]/drupal/drush/policy.drush.inc
        * [project]/drupal/scripts/composer/ScriptHandler.php
        * [project]/drupal/.gitignore
        * [project]/drupal/phpunit.xml.dist
10. Edit project .gitignore
    * edit [project]/.gitignore to adapt to the new directory structure
11. Add settings files to project repo
    * [project]/drupal/web/sites/default/settings.php (copy from some other project like Nivos)
    * [project]/drupal/web/sites/default/settings.silta.php (copy from some other project like Nivos)
    * [project]/drupal/web/sites/default/settings.local.php (= [project]/drupal/conf/lando.settings.php)
        * build.sh doesn't work yet, so this is a temporary solution


## Possible obstacles

### Drupal module compatibility with newer PHP version
