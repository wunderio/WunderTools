<?php
use Behat\Behat\Tester\Exception\PendingException;
use Behat\Behat\Hook\Scope\AfterStepScope;
use Behat\Mink\Driver\Selenium2Driver;
use Behat\Behat\Context\SnippetAcceptingContext;

/**
 * Defines application features from the specific context.
 */
class FeatureContext extends Behat\MinkExtension\Context\MinkContext implements SnippetAcceptingContext{
    /**
   * Initializes context.
   *
   * Every scenario gets its own context instance.
   * You can also pass arbitrary arguments to the
   * context constructor through behat.yml.
   */
  public function __construct()
  {
    $this->debugger = new Debugger($this);
    $this->logger = new Logger($this);
  }

  /**
   * Take a screenshot and save html when step fails. Works only with Selenium2Driver.
   *
   * @AfterStep
   * @param AfterStepScope $scope
   */
  public function takeScreenshotAfterFailedStep(Behat\Behat\Hook\Scope\AfterStepScope $scope)
  {
    if (99 === $scope->getTestResult()->getResultCode()) {
      $this->debugger->getScreenshot($scope);
      $this->debugger->saveHtml($scope);
    }
  }

  /**
  * CUSTOM IMPLEMENTATIONS
  */
  /**
   * @Then I should find :arg1
   */
  public function iShouldFind($arg1)
  {
      return $this->getSession()->getPage()->find('css',$arg1);
  }

  /**
   * @Then I should read :arg1
   */
  public function iShouldRead($arg1)
  {
    $escapedValue = $this->getSession()->getSelectorsHandler()->xpathLiteral($arg1);
    $text = $this->getSession()->getPage()->find('named', array('content', $escapedValue));
    if(isset($text) && ($text != NULL)){
      return true;
    }else{
      throw new Exception("Can't find the text: '".$arg1."' on the page.");
    }
  }
  /**
   * @When I submit the form :arg1
   */
  public function iSubmitTheForm($arg1)
  {
      $element = $this->getSession()->getPage()->find("css", $arg1);
      if($element != NULL){
        var_dump($element);
      }else{
        throw new Exception("Can't find any form with the css selector: '".$arg1."' on the page.");
      }
  }


  /**
   * @Given I am logged in as :arg1
   */
  public function iAmLoggedInAs($arg1)
  {
    return $this->logger->iLoginAs($arg1);
  }

}
