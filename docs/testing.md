Testing instructions
========================
Tests can be found under test/ folder.
Test are run using Behat, Mink and Drupal Extension for behat & mink.

To get started cd into test folder and follow these steps:
1. Install selenium server from [http://docs.seleniumhq.org/download/](http://docs.seleniumhq.org/download/)
2. Run selenium:

    `java -jar selenium-server-standalone-x.xx.x.jar &`

  note the version you downloaded and adjust accordingly
3. Install requirements with composer

    `composer install`

4. Run tests

    `bin/behat --maybe-needs --some-flags=here`
