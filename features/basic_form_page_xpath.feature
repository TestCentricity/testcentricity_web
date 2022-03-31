@!grid @!mobile @!headless


Feature: Basic HTML Form Test Page using Xpath locators
  In order to ensure comprehensive support for HTML UI elements and forms
  As a developer of the TestCentricity web gem
  I expect to validate the interaction and verification capabilities of typical HTML form UI elements


  Background:
    Given I am on the Basic Xpath Form page


  Scenario: Validate verify_ui_states method and associated object state verification methods
    Then I expect the Basic Xpath Form page to be correctly displayed


  Scenario: Validate verify_focus_order method
    Then I expect the tab order to be correct


  Scenario: Validate populate_data_fields method and associated object action methods
    When I populate the form fields
    Then I expect the form fields to be correctly populated
    When I cancel my changes
    Then I expect the Basic Xpath Form page to be correctly displayed
