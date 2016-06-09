<?php
use Behat\Behat\Hook\Scope\AfterStepScope;

class Logger {

  /** @var \FeatureContext */
  private $featureContext;
  private $users = array("admin" => "admin");

  public function __construct(\FeatureContext $featureContext) {
    $this->featureContext = $featureContext;
  }

  public function iLoginAs($user){
    if(isset($this->users[$user])){
      $this->featureContext->visit("user");
      $name = $this->featureContext->getSession()->getPage()->findField("name");
      $name->setValue($user);
      $pass = $this->featureContext->getSession()->getPage()->findField("pass");
      $pass->setValue($this->users[$user]);
      $login = $this->featureContext->getSession()->getPage()->find("css","#edit-submit");
      $login->click();

      $escapedValue = $this->featureContext->getSession()->getSelectorsHandler()->xpathLiteral($user);
      $text = $this->featureContext->getSession()->getPage()->find('named', array('content', $escapedValue));
      if(isset($text) && ($text != NULL)){
        return true;
      }else{
        throw new Exception("Can't login as the user ".$user." with password: '".$this->users[$user]."'. Check its credentials are ok in the \$users array");
      }
    }else{
      throw new Exception("Can't find the user ".$user." in the test user array. Edit the Logger.php class and add its credentials :).");
    }
  }
}
