@jobs @JIRA-Epic:APP-200
Feature: Job execution
  As a field agent
  I want to run an assigned job on the phone
  So that status, notes and search stay consistent

  Background:
    Given the field app is launched
    And the agent is signed in

  @TC-06 @APP-201 @smoke
  Scenario: Job list shows three open jobs
    When the agent opens the job list
    Then three open jobs are listed

  @TC-07 @APP-202
  Scenario: Job detail opens as assigned
    When the agent opens job "1001"
    Then job detail shows status "ASSIGNED"

  @TC-08 @APP-203
  Scenario: Starting a job moves it to in progress
    When the agent opens job "1001"
    And the agent starts the job
    Then job detail shows status "IN_PROGRESS"

  @TC-09 @APP-204
  Scenario: Completing a started job marks it completed
    When the agent opens job "1001"
    And the agent starts the job
    And the agent completes the job
    Then job detail shows status "COMPLETED"

  @TC-10 @APP-205
  Scenario: Agent can attach a site note
    When the agent opens job "1001"
    And the agent adds the note "Meter replaced"
    Then the job note is "Meter replaced"

  @TC-11 @APP-206
  Scenario: Search finds a job by sku text
    When the agent searches for "meter"
    Then the search result contains "1001"
