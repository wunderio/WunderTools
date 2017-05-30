<?php

class ExampleAcceptanceCest {

  /**
   * @param \FunctionalTester $I
   */
  public function exampleAcceptanceTest(FunctionalTester $I) {
    $I->amOnPage('/');
    $I->seeResponseCodeIs(200);
  }

}
