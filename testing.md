Testing instructions
========================
Tests can be found under drupal/tests folder.
Test are run using Codeception.

To get started, follow these steps:
1. Uncomment or add selenium role in environment(s) that you will run tests on:

    `- { role: selenium, tags: [ 'selenium' ] }`
    
2. Provision:

    `vagrant provision`
    
    or
    
    `./provision.sh -t selenium -u www-admin envnamehere`

3. Install requirements with composer

    `composer install`

4. Run tests

    `./build.sh test`

    or run codecept directly and specify options as needed

    `vendor/bin/codecept run -c web/codeception.yml --env test`

Writing tests
------------------
To add your own tests, cd to web directory and

    `../vendor/bin/codecept generate:cest acceptance MyFirstTestCest`


There are four test suites available out of the box:

* Acceptance - For testing site with real browser (Chrome or Firefox)
* Functional - For testing backend interactions that might use browser (PhpBrowser), but does not depend on JS.
* Unit - For Unit testing custom code methods.
* Visual - For visual regression testing.


Tests are written in simple OOP way that is easy to write and read. Example: 

    $I->am('user');
    $I->wantTo('login to website');
    $I->lookForwardTo('access website features for logged-in users');
    $I->amOnPage('/login');
    $I->fillField('Username','davert');
    $I->fillField('Password','qwerty');
    $I->click('Login');
    $I->see('Hello, davert');

## More information

There is extensive documentation available for [Codeception](http://codeception.com/docs/).

More about how to [configure testing framework](http://codeception.com/docs/reference/Configuration).

List of [commands available](http://codeception.com/docs/reference/Commands).
