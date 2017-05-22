<?php


class DoDCest {

  public function adminPasswordIsNotAdminTest(AcceptanceTester $I) {
    $I->amOnPage('/user/login');
    $I->fillField('name', 'admin');
    $I->fillField('//*[@id="edit-pass"]', 'admin');
    $I->click('#edit-submit');
    $I->See('Unrecognized username or password.');
  }

  /**
   * @inheritdoc
   */
  public function _after() {
    $this->floodUnblock();
    $this->floodUnblock('user.failed_login_user', '1-127.0.0.1');
  }

  /**
   * @inheritdoc
   */
  public function _failed() {
    $this->_after();
  }

  /**
   * Clears drupal flood table
   *
   * @param string $type
   * @param string $identifier
   */
  private function floodUnblock($type = 'user.failed_login_ip', $identifier = '127.0.0.1') {
    $txn = \Drupal::database()->startTransaction('flood_unblock_clear');
    try {
      $query = \Drupal::database()->delete('flood')
        ->condition('event', $type);
      if (isset($identifier)) {
        $query->condition('identifier', $identifier);
      }
      $query->execute();
    }
    catch (\Exception $e) {
      // Something went wrong somewhere, so roll back now.
      $txn->rollback();
      // Log the exception to watchdog.
      watchdog_exception('type', $e);
    }
  }

}
