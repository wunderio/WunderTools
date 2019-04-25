# Converting Drupal 7 WunderTools projects to use Composer

## Workflow

1. Install [Lando](https://docs.devwithlando.io/) (and [Docker if using Linux](https://docs.devwithlando.io/installation/linux.html))
2. Copy `composer.json` from [WunderTools](https://github.com/wunderio/WunderTools/tree/drupal7/) project and use it as a base
3. Convert `.make` file into raw composerfile: `drush make-convert [project]/drupal/conf/site.make --format=composer > [project]/drupal/raw-composer.json`. If the project doesn't have a `.make` file, create one: `drush generate-makefile site.make`
4. Copy-paste project specific components (`require`, `patches` etc) from the generated `raw-composer.json` to the `composer.json` copied from WunderTools

## Possible obstacles

### Drupal module compatibility with newer PHP version
