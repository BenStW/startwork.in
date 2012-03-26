Feature: user maintains friendships
  As a user
  I want maintain my friends
  so that I can work with them on startwork

  Scenario: user adds a friend
    Given an active, logged-in user "Ben"
    And the active user with name "Steffi"
    When the user goes to "friendships"
    And the user presses "Add as work-buddy"
    Then the user sees "Remove as work-buddy"

  Scenario: user removes a friend
    Given an active, logged-in user "Ben"
    And the active user with name "Steffi"
    When the user goes to "friendships"
    And the user presses "Add as work-buddy"
    And the user presses "Remove as work-buddy"
    Then the user does not sees "Remove as work-buddy"
