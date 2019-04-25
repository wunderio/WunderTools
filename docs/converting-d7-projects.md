# Converting Drupal 7 projects to use Composer

## Why one should do this
* to use continuous integration
* .make file isn't developed anymore
* composer is a modern tool


## Workflow

1. Install composer

2. Converting .make file into composer.json
  * Copy composer.json from [drupal-composer](https://github.com/drupal-composer/drupal-project/tree/7.x) project and use it as a base 
  * If the project doesn't have a .make file, create one: `drush generate-makefile site.make`
  * When you have .make file, convert it into composer.json: `drush make-convert [project]/drupal/conf/site.make --format=composer > [project]/drupal/composer.json`
  * Copy-paste project specific definitions from the generated composer.json to the one copied from drupal-composer project


## Possible obstacles

### Drupal module compatibility with newer PHP version
