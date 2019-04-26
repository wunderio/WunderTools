#!/usr/bin/env bash
set -euxo pipefail

echo "This script will convert your Drupal 7 project to be compatible with composer, lando and Silta."
echo "Make sure you are in the git root of your project."

echo "Checking dependencies"
git --version
composer --version
lando version
json_pp -v

# Use the current directory as the project name
CURRENT_PATH=`pwd`
PROJECT_NAME=`basename $CURRENT_PATH`

# Update build.sh
curl -s https://raw.githubusercontent.com/wunderio/WunderTools/drupal7/build.sh > build.sh
curl -s https://raw.githubusercontent.com/wunderio/WunderTools/drupal7/drupal/build.sh > drupal/build.sh

# Update site.yml
mv drupal/conf/site.yml drupal/conf/site.yml.old
curl -s https://raw.githubusercontent.com/wunderio/WunderTools/drupal7/drupal/conf/site.yml > drupal/conf/site.yml

# Download lando configuration file, renaming the project on the way.
curl -s https://raw.githubusercontent.com/wunderio/WunderTools/drupal7/drupal/.lando.yml | sed "s/wundertools/$PROJECT_NAME/" > drupal/.lando.yml

# Download the base composer file.
curl -s https://raw.githubusercontent.com/wunderio/WunderTools/drupal7/drupal/composer.json > drupal/composer.json
curl -s https://raw.githubusercontent.com/wunderio/WunderTools/drupal7/drupal/.gitignore > drupal/.gitignore
mkdir -p drupal/scripts/composer
curl -s https://raw.githubusercontent.com/drupal-composer/drupal-project/7.x/scripts/composer/ScriptHandler.php > drupal/scripts/composer/ScriptHandler.php
mkdir -p drupal/drush
curl -s https://raw.githubusercontent.com/drupal-composer/drupal-project/7.x/drush/policy.drush.inc > drupal/drush/policy.drush.inc

# Add the various settings and env files.
mkdir -p drupal/web/sites/default
curl -s https://raw.githubusercontent.com/wunderio/WunderTools/drupal7/drupal/web/sites/default/settings.php > drupal/web/sites/default/settings.php
curl -s https://raw.githubusercontent.com/wunderio/WunderTools/drupal7/drupal/web/sites/default/settings.lando.php | sed "s/wundertools/$PROJECT_NAME/" > drupal/web/sites/default/settings.lando.php
curl -s https://raw.githubusercontent.com/wunderio/WunderTools/drupal7/drupal/.env > drupal/.env

# Add silta files
if [[ -z "${SKIP_SILTA_FILES:-}" ]] ; then
  mkdir -p drupal/silta
  curl -s https://raw.githubusercontent.com/wunderio/drupal-project/master/silta/nginx.Dockerfile > drupal/silta/nginx.Dockerfile
  curl -s https://raw.githubusercontent.com/wunderio/drupal-project/master/silta/php.Dockerfile > drupal/silta/php.Dockerfile
  curl -s https://raw.githubusercontent.com/wunderio/drupal-project/master/silta/shell.Dockerfile > drupal/silta/shell.Dockerfile
  curl -s https://raw.githubusercontent.com/wunderio/drupal-project/master/silta/silta.yml > drupal/silta/silta.yml
  curl -s https://raw.githubusercontent.com/wunderio/drupal-project/master/silta/silta-prod.yml > drupal/silta/silta-prod.yml
  curl -s https://raw.githubusercontent.com/wunderio/drupal-project/master/.dockerignore > drupal/.dockerignore
  curl -s https://raw.githubusercontent.com/wunderio/drupal-project/master/web/.dockerignore > drupal/web/.dockerignore
  curl -s https://raw.githubusercontent.com/wunderio/WunderTools/drupal7/drupal/web/sites/default/settings.silta.php > drupal/web/sites/default/settings.silta.php
else
  echo "Skipping silta files"
fi

# Run composer install so we have the scaffolding in place.
composer install --working-dir=drupal --no-suggest --ignore-platform-reqs
rm drupal/composer.lock
mv drupal/composer.json drupal/base-composer.json

# Move drush aliases
mkdir -p drupal/drush
if find drupal/conf | grep -q drushrc ; then
  git mv `find drupal/conf | grep drushrc` drupal/drush/
fi

# Move custom code to the right place
git mv drupal/code/modules/custom drupal/web/sites/all/modules/custom
git mv drupal/code/modules/features drupal/web/sites/all/modules/features
rmdir drupal/code/modules

git mv drupal/code/themes/custom drupal/web/sites/all/themes/custom
rmdir drupal/code/themes

if [ -d drupal/code/libraries ] ; then
  git mv drupal/code/libraries drupal/web/sites/all/libraries
fi
if find drupal/web/sites/all/libraries | grep -q ".zip" ; then
  printf "\e[33mThe following libraries have zip files, you might need to unpack them.\e[0m\n"
  find drupal/web/sites/all/libraries | grep ".zip"
fi

git mv drupal/code/profiles drupal/web/sites/all/profiles

# Move patches to the right place
if [ -d drupal/conf/patches ] ; then
  git mv drupal/conf/patches drupal/patches
fi
if [ -d drupal/code/patches ] ; then
  git mv drupal/code/patches drupal/patches
fi

if [ -d drupal/patches ] ; then
  printf "\e[33mPlease make sure that the following patches are included in composer.json and are still relevant.\e[0m\n"
  ls -l drupal/patches
fi

# Remove the code folder.
# This should be empty at this point, otherwise a failure is intentional.
rmdir drupal/code

# Add CircleCI configuration
mkdir -p .circleci
curl -s https://raw.githubusercontent.com/wunderio/WunderTools/drupal7/.circleci/config.yml > ./.circleci/config.yml

# For now, assume we have a Wundertools repo
drupal_root="drupal"

SITE_MAKE=`find . -name site.make`
drupal/vendor/bin/drush make-convert $SITE_MAKE --format=composer > /tmp/raw-composer.json

php -r '
$baseComposerJson = json_decode(file_get_contents("drupal/base-composer.json"), true);
$generatedComposerJson = json_decode(file_get_contents("/tmp/raw-composer.json"), true);

// Merge required packages.
$baseComposerJson["require"] += $generatedComposerJson["require"];

// Add patches if there are any.
if (isset($generatedComposerJson["extra"]["patches"])) {
  $baseComposerJson["extra"]["patches"] = $generatedComposerJson["extra"]["patches"];
}

// Mark dev modules as dev dependencies.
if (isset($baseComposerJson["require"]["drupal/devel"])) {
  $baseComposerJson["require-dev"]["drupal/devel"] = $baseComposerJson["require"]["drupal/devel"];
  unset($baseComposerJson["require"]["drupal/devel"]);
}

// Initially keep the version locked.
foreach ($baseComposerJson["require"] as $name => $version) {
  if (!$version) {
    $version = "*";
  }
  $baseComposerJson["require"][$name] = str_replace("^", "", $version);
}

echo json_encode($baseComposerJson);
' | json_pp > drupal/composer.json

if ! composer validate --working-dir=drupal ; then
  printf "\e[33mThe generated composer.json has issues, please fix the errors above.\e[0m\n"
fi
