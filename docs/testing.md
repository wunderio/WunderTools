Testing instructions
========================
Tests can be found under test/ folder.
Test are run using Behat and Mink.

To get started cd into test folder and follow these steps:
1. Install selenium server from [http://docs.seleniumhq.org/download/](http://docs.seleniumhq.org/download/) tested lately with 2.52.0 version
2. Run selenium:

    `java -jar selenium-server-standalone-x.xx.x.jar &`

  note the version you downloaded and adjust accordingly
3. Get also the [chromedriver] (https://sites.google.com/a/chromium.org/chromedriver/downloads) and launch it. Remember to always get it updated when you update your chrome browser!
4. Install requirements with composer

    `composer install`

5. Run tests

    `bin/behat --maybe-needs --some-flags=here`

    a useful flag is __--name__ that allows you to run only one scenario at a time so that you don't need to wait for the whole suite to run.

    `bin/behat --name='admins can create basic pages'`

Writing tests
------------------
To add your own tests, simply add a .feature file to the features and expand!

A couple examples can already be found under test/features and include logging in and creating a basic page node. Since testing is very bound to a project itself, we couldn't think of any other useful example test :(.
The good news is **writing tests is easy**!! and most of all, __fun__!
Already bundled in WunderTools you'll find a couple Classes that can help you in the task: Debugger and Logger.

### Debugger.php
In the Debugger class you should configure some variables with the paths where it can save the screenshots and HTML of the failing tests.
These are the defaults:
```php
private $screenshot_path = '/var/www/html/screenshots';
private $screenshot_url = 'http://localhost/screenshots';
private $html_dump_path = '/var/www/html/screenshots_html';
private $html_dump_url = 'http://localhost/screenshots_html';```
This way when a test fails it saves a screenshot and the HTML on your local environment for debugging purposes so that you can go and see where's the problem.

### Logger.php
This class can be used to log users in and tests for example role's permissions and so on.
You should add your test users to the $users private variable
```php
private $users = array("admin" => "admin");```
in username => password format. Then to log a user in you can just write in your test:
`Given I am logged in as "username"`
and __profit__!
