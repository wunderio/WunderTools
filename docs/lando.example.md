# Modifying local .lando.yml files

## Drupal multisite

Add these into your .lando.yml proxy and make sure that drupal/web/sites/site.php has the same domain names.

```
proxy:
  appserver:
    - domain.lndo.site
    - domain2.lndo.site
```

# Syncdb

There is a tool defined as `syncdb`, this calls a script in drupal/scripts/syncdb.sh that a developer can create and make sure works. This is intended to be used so that every developer has the ability easily to sync database to local properly and following the local laws (gdpr etc).

