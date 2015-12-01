<?php

use Drupal\DrupalExtension\Context\RawDrupalContext;
use Behat\Behat\Context\SnippetAcceptingContext;
use Behat\Gherkin\Node\PyStringNode;
use Behat\Gherkin\Node\TableNode;

/**
 * Defines application features from the specific context.
 */
class FeatureContext extends Behat\MinkExtension\Context\MinkContext {

  /**
   * @BeforeSuite
   */
  public static function setupSuite(SuiteEvent $event) {
    $behatContext = new BehatContext();
    $behatContext->printDebug('Context parameters: ' . json_encode($event->getContextParameters()));
  }

  /**
   * Initializes context.
   *
   * Every scenario gets its own context instance.
   * You can also pass arbitrary arguments to the
   * context constructor through behat.yml.
   */
  public function __construct() {
  }

  /**
   * Custom step definition. Step definitions are mapped to matching PHP
   * functions using regular expressions. Step definitions can have input
   * placeholders.
   *
   * @When /^I search for "([^"]*)"$/
   */
  public function iSearchFor($text) {
    return array(
      new Step\When('I fill in "edit-search-api-views-fulltext" with "'.$text.'"'),
      new Step\When('I press "edit-submit-ns-prod-enterprise-search"'),
    );
  }
}
