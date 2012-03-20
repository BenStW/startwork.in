Feature: user maintains friendships
  As a user
  I want maintain my friends
  so that I can work with them on startwork

  Scenario: user adds a friend
    Given the user "Ben"
    When he signs in
    And he visits the friends page
    And he adds the user "Steffi" as a friend
    Then the user "Steffi" is defined as a friend

  Scenario: user removes a friend
    Given the user "Ben"
    When he signs in
    And he visits the friends page
    And he adds the user "Steffi" as a friend
    And he removes the user "Steffi" as a friend
    Then the user "Steffi" is not defined as a friend