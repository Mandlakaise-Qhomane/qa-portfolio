@auth @JIRA-Epic:APP-100
Feature: Field agent authentication
  As a field agent
  I want to sign in on a phone
  So that only a valid depot agent can work jobs

  Background:
    Given the field app is launched

  @TC-01 @APP-101 @smoke
  Scenario: App launch shows the branded sign-in screen
    Then the sign-in screen is shown

  @TC-02 @APP-102 @smoke
  Scenario: Valid agent credentials open home
    When the agent signs in with valid credentials
    Then the home screen is shown

  @TC-03 @APP-103 @negative
  Scenario: Invalid password is rejected
    When the agent signs in with agent "agent.jhb" and password "wrong"
    Then a login error is shown

  @TC-04 @APP-104 @negative
  Scenario: Blank agent id is rejected
    When the agent signs in with agent "" and password "Field@123"
    Then a login error is shown

  @TC-05 @APP-105
  Scenario: Agent can log out
    Given the agent is signed in
    When the agent logs out
    Then the sign-in screen is shown
