Feature: user tests camera and audio
  As a user
  I want to test my camera and audio
  so that I can use it when the work session starts

  Scenario: camera and audio works
    Given a logged-in facebook user "Ben"
    And TokBox is unstubbed
    When the user goes to "camera"
    And the user hits "Yes, everything went fine"
    And the user hits "Yes, everything went fine"
    Then the user sees "Great, glad that everything went fine."

  Scenario: camera work, audio does not work
    Given a logged-in facebook user "Ben"
    And TokBox is unstubbed
    When the user goes to "camera"
    And the user hits "Yes, everything went fine"
    And the user hits "No, I experienced problems"
    Then the user sees "Thank you, we wil contact you concerning your technical problems."

  Scenario: camera does not work, audio works
    Given a logged-in facebook user "Ben"
    And TokBox is unstubbed
    When the user goes to "camera"
    And the user hits "No, I experienced problems"
    And the user hits "Yes, everything went fine"
    Then the user sees "Thank you, we wil contact you concerning your technical problems."

  Scenario: camera does not work, audio does not work
    Given a logged-in facebook user "Ben"
    And TokBox is unstubbed
    When the user goes to "camera"
    And the user hits "No, I experienced problems"
    And the user hits "No, I experienced problems"
    Then the user sees "Thank you, we wil contact you concerning your technical problems."