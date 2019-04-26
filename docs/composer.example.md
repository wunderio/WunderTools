# Examples for adding new stuff into composer.json

## Specific module commit of module

Define a new package in your `repositories{}` block, and then add that into your `require{}` block.

```
{
  "type": "package",
  "package": {
    "name": "drupal/nodequeue",
    "version": "7.0",
    "type": "drupal-module",
    "source": {
      "url": "https://git.drupal.org/project/nodequeue.git",
      "type": "git",
      "reference": "afd0d258dc5e47533da568523eaf986e50f3f34b"
    }
  }
}
```  

Note, version can be anything you want, as long as you specify the same version in your `require{}` block. In this example we've used an arbitrary 7.0 version which is absurdly high to make sure we differentiate our specific versions in our `require{}` block. This might make it easier to find these kind of packages.

## New Drupal library

Define a new package in your `repositories{}` block, and then add that into your `require{}` block.

```
{
  "type": "package",
  "package": {
    "name": "wunderio/ckeditor",
    "version": "4.10.1",
    "type": "drupal-library",
    "dist": {
      "url": "https://download.cksource.com/CKEditor/CKEditor/CKEditor%204.10.1/ckeditor_4.10.1_full.zip",
      "type": "zip"
    }
  }
}
```

Note, version can be anything you want, as long as you specify the same version in your `require{}` block. To be consistent, it would be wise to use the same version number you are actually adding of the library.

## New CKEditor Plugin / Skin

Add this into your `require{}` block, it will allow you to define new installer types and later define where those installer types should be put.

`"oomphinc/composer-installers-extender": "^1.1",`

Add this into your `extra{}` block, this will define a new type.

`"installer-types": ["ckeditor-plugin"],`

Add a new installer paths into `installer-paths{}` block, and make sure the path is proper for your specific project.

`"web/sites/all/libraries/ckeditor/plugins/{$name}": ["type:ckeditor-plugin"],`

Then define a new package into your `repositories{}` block.

```
{
  "type": "package",
  "package": {
    "name": "ckeditor-plugin/lineutils",
    "version": "4.10.1",
    "type": "ckeditor-plugin",
    "require": {
      "composer/installers": "~1.0"
    },
    "dist": {
      "url": "https://download.ckeditor.com/lineutils/releases/lineutils_4.10.1.zip",
      "type": "zip"
    }
  }
}
```

## Multisite projects

If you have a multisite project you might need to edit your `preserve-paths{}` and add all the `web/sites/dommain.tld` into there so that they are not removed.
