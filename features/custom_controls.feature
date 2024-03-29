Feature: Custom Controls
  In order to ensure comprehensive support for custom UI elements
  As a developer of the TestCentricity web gem
  I expect to validate the interaction and verification capabilities of custom UI elements


  Background:
    Given I am on the Custom Controls page


  Scenario: Validate populate_data_fields method and associated object action methods
    When I populate the form fields
    Then I expect the form fields to be correctly populated


@!safari @!firefox @!firefox_headless @!ios
  Scenario: Use custom select list input field to choose options
    When I choose custom select options by typing
    Then I expect the form fields to be correctly populated


  Scenario Outline:  Choose selectlist options by index and text
    When I choose selectlist options by <method>
    Then I expect the selected option to be displayed

    Examples:
      |method |
      |index  |
      |text   |
