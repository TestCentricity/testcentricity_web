Feature: Basic HTML Form Test Page using CSS locators
  In order to ensure comprehensive support for HTML UI elements and forms
  As a developer of the TestCentricity web gem
  I expect to validate the interaction and verification capabilities of typical HTML form UI elements


  Background:
    Given I am on the Basic CSS Form page


  Scenario: Validate verify_ui_states method and associated object state verification methods
    Then I expect the Basic CSS Form page to be correctly displayed


@!mobile @!firefox_headless
  Scenario: Validate verify_focus_order method
    Then I expect the tab order to be correct


  Scenario: Validate populate_data_fields method and associated object action methods
    When I populate the form fields
    Then I expect the form fields to be correctly populated
    When I cancel my changes
    Then I expect the Basic CSS Form page to be correctly displayed


  Scenario Outline:  Verify functionality of navigation tabs and browser back/forward
    When I click the <target_page> navigation tab
    Then I expect the <target_page> page to be correctly displayed
    When I navigate back
    Then I should be on the Basic CSS Form page
    When I navigate forward
    Then I should be on the <target_page> page

    Examples:
      |target_page      |
      |Media Test       |
      |Indexed Sections |
      |Custom Controls  |
