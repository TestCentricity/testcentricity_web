Feature: Basic Indexed Sections
  In order to ensure comprehensive support for indexed sections
  As a developer of the TestCentricity web gem
  I expect to validate the interaction and verification capabilities of indexed section elements


  Background:
    Given I am on the Indexed Sections page

@!safari @!mobile
  Scenario Outline:  Verify clickable actions on indexed sections
    When I <action> product card <num>
    Then I expect a modal alert to be displayed

  Examples:
    |action       |num |
    |double click |1   |
    |right click  |2   |
    |click at     |3   |
