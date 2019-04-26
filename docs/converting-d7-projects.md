# Converting Drupal 7 WunderTools projects to use Composer

## Prologue
This is still a work in progress. If converting projects according to this documentation, try and do the steps in a sensible order. Also note there are some extra steps for multisites.

## Automated upgrade
We have a script to automate as much of the process as possible. You can run it as follows:

```bash
curl -s https://raw.githubusercontent.com/wunderio/WunderTools/drupal7/upgrade-legacy-d7.sh | bash
```

If you are working on a repository managed on the client's infrastructure, you can skip silta files like this:

```bash
curl -s https://raw.githubusercontent.com/wunderio/WunderTools/drupal7/upgrade-legacy-d7.sh | SKIP_SILTA_FILES=1 bash
```

After running the script, you will need the following manual steps (and maybe more):

1. Clean up and edit composer.json to be suitable for the project
    * change the project name and description
    * define needed repositories (all that say "Enter correct project name and version number")
    * there might be module versions that have * in them - those need to be corrected
 
2. Make sure site.yml includes any required customizations.   
    * if there are project specific things in commands.yml or site.yml.old, move them to the new site.yml
    * remove commands.yml and site.yml.old
    * note: if you have some other files under conf, move them to correct directories.

3. For multisites
    * add the subsites under "preserve-paths" instead of "web/sites/default"
    * for multisite, add the following to your .lando.yml:
        ```
        proxy:
          appserver_nginx:
            - domain1.lndo.site
            - domain2.lndo.site
        domain1_db:
          type: mariadb:10.2
          config:
            confd: config
        domain2_db:
          type: mariadb:10.2
          config:
            confd: config
        ```

4. Install [Lando](https://docs.devwithlando.io/) (and [Docker if using Linux](https://docs.devwithlando.io/installation/linux.html))

5. Build the project
    * start lando: `lando start` (note: this tries to build the project - be cautious of any errors)
6. Import database and update db
    * import db: `lando db-import [dumpname].sql`
    * run updb: `lando drush updb`

## Possible obstacles

* HTML Purifier
    * http://htmlpurifier.org/releases/htmlpurifier-4.8.0.tar.gz
    ```
    [UnexpectedValueException]
    internal corruption of phar "/app/web/sites/all/libraries/htmlpurifier/5312b6822fe047eef6dbaac17a8ed9a5.gz" (__HALT_COMPILER(); not found)
    ```
    * solution: update to latest version
* Webform
    ```
    - Installation request for drupal/webform_rules 1.6 -> satisfiable by drupal/webform_rules[1.6.0].
    - Can only install one of: drupal/webform[4.17.0, 3.x-dev].
    - drupal/webform_rules 1.6.0 requires drupal/webform ^3 -> satisfiable by drupal/webform[3.x-dev].
    - Installation request for drupal/webform 4.17 -> satisfiable by drupal/webform[4.17.0].
    ```
