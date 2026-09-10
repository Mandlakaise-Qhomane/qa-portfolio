@login @JIRA-Epic:GURU-100
Feature: Manager authentication
  As a bank manager
  I want to sign in to Guru99 Bank V4
  So that I can work only with a valid manager account

  Background:
    Given the manager is on the Guru99 Bank login page

  @TC-01 @GURU-101 @smoke
  Scenario: Valid manager credentials open the home page
    When the manager logs in with valid credentials
    Then the manager home page is displayed

  @TC-02 @GURU-102 @negative
  Scenario: Invalid password is rejected
    When the manager logs in with user "mngr000000" and password "wrongPass"
    Then an authentication alert is shown containing "User or Password is not valid"

  @TC-03 @GURU-103 @negative
  Scenario: Blank user id is rejected
    When the manager logs in with user "" and password "secret"
    Then an authentication alert is shown containing "User or Password is not valid"
