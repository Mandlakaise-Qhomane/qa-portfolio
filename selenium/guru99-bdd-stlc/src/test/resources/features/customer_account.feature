@customer @JIRA-Epic:GURU-200
Feature: Customer and account servicing
  As a bank manager
  I want to register customers and post account movements
  So that balances stay correct

  Background:
    Given the manager is on the Guru99 Bank login page
    And the manager logs in with valid credentials

  @TC-04 @GURU-201 @negative
  Scenario: New customer name rejects digits
    When the manager opens New Customer
    And the manager enters customer name "John123"
    Then a field message containing "Numbers are not allowed" is shown

  @TC-05 @GURU-202 @smoke
  Scenario: New customer can be created
    When the manager opens New Customer
    And the manager submits a valid new customer form
    Then a customer identifier is issued

  @TC-06 @GURU-203
  Scenario: Savings account can be opened
    When the manager opens New Customer
    And the manager submits a valid new customer form
    And the manager opens New Account
    And the manager opens a Savings account with deposit "5000"
    Then an account identifier is issued

  @TC-07 @GURU-204
  Scenario: Deposit increases the account
    When the manager opens New Customer
    And the manager submits a valid new customer form
    And the manager opens New Account
    And the manager opens a Savings account with deposit "5000"
    And the manager deposits "250" with description "salary"
    Then a transaction confirmation is shown

  @TC-08 @GURU-205
  Scenario: Withdrawal within balance is accepted
    When the manager opens New Customer
    And the manager submits a valid new customer form
    And the manager opens New Account
    And the manager opens a Savings account with deposit "5000"
    And the manager withdraws "100" with description "atm"
    Then a transaction confirmation is shown

  @TC-09 @GURU-206 @negative
  Scenario: Withdrawal over balance is rejected
    When the manager opens New Customer
    And the manager submits a valid new customer form
    And the manager opens New Account
    And the manager opens a Savings account with deposit "500"
    And the manager withdraws "50000" with description "overdraw"
    Then a transaction alert is shown

  @TC-10 @GURU-207
  Scenario: Manager can log out
    When the manager logs out
    Then the login page is displayed after logout
