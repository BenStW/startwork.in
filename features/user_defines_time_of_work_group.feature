Feature: user defines time of work group
  As a user
  I want to define the time of my work group
  so that I can join the work group at this time

  #@javascript
  Scenario: user defines time of work group
    Given the user "Ben"
    And a work group
    When he signs in
    And he visits the page of the work group
    And he selects the day "tomorrow"
    And he selects the hour "10"
    Then this definition is saved successfully