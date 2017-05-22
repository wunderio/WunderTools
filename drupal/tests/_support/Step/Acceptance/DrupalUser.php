<?php

namespace Step\Acceptance;

use Drupal\user\Entity\User;

/**
 * Class DrupalUser
 * @package Step\Acceptance
 */
class DrupalUser extends \AcceptanceTester {

  /**
   * Login as user with role $role.
   *
   * @param string $role
   */
  public function logInAs($role) {
    $I = $this;
    $I->amOnPage('/user/login');
    $username = "test{$role}User";
    $I->logIn($username, $username);
  }

  /**
   * Log in with username and password.
   *
   * @param string $username
   * @param string $pass
   */
  public function logIn($username, $pass) {
    $I = $this;
    $I->amOnPage('/user/login');
    $I->submitForm('#user-login-form', [
      'name' => $username,
      'pass' => $pass,
    ]);
    $I->dontSee('Unrecognized username or password');
    $I->seeInTitle($username);
  }

  /**
   * Log out current user.
   */
  public function logOut() {
    $I = $this;
    $I->amOnPage('/user/logout');
    $I->dontSeeInCurrentUrl('user');
  }

  /**
   * Get user id by username.
   *
   * @param string $username
   *
   * @return mixed
   */
  public function getUserId($username) {
    $uids = \Drupal::entityQuery('user')
      ->condition('name', $username)
      ->execute();
    return reset($uids);
  }

  /**
   * Get one time access and log in.
   *
   * @param string $username
   */
  public function useOneTimeLoginFor($username) {
    $I = $this;
    $url = user_pass_reset_url(User::load($this->getUserId($username)));
    $I->amOnPage($url);
    $I->click('#edit-submit');
  }

}
