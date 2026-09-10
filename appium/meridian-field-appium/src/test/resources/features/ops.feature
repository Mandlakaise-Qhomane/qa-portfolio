@ops @JIRA-Epic:APP-300
Feature: Field operations
  As a field agent
  I want priority, offline and session controls on the phone
  So that I can work away from the office

  Background:
    Given the field app is launched
    And the agent is signed in

  @TC-12 @APP-301
  Scenario: Priority queue lists only high jobs
    When the agent opens the priority queue
    Then only high-priority jobs are listed

  @TC-13 @APP-302
  Scenario: Offline banner is visible
    When the agent opens the offline queue
    Then the offline banner is shown

  @TC-14 @APP-303
  Scenario: Depot can be changed in settings
    When the agent changes depot to "CPT-West"
    Then the home depot chip is "CPT-West"

  @TC-15 @APP-304
  Scenario: Idle timeout ends the session
    When the agent triggers an idle timeout
    Then the session-expired screen is shown
