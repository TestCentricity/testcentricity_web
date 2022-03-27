Feature: Basic HTML Test Page using CSS locators
  In order to xxx
  As a xxxx
  I expect to xxxx


  Background:
    Given I am on the Basic CSS Test page


  Scenario: xxxxx
    Then I expect the Basic CSS Test page to be correctly displayed


@!mobile
  Scenario: xxxxx
    Then I expect the tab order to be correct


  Scenario: xxxxx
    When I populate the form fields
    Then I expect the form fields to be correctly populated
    When I cancel my changes
    Then I expect the Basic CSS Test page to be correctly displayed


  Scenario Outline:  Verify functionality of navigation tabs
    When I click the <target_page> navigation tab
    Then I expect the <target_page> page to be correctly displayed

    Examples:
      |target_page      |
      |Media Test       |
      |Indexed Sections |
      |Custom Controls  |
