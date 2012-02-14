Feature: A user looks at the homepage

   As a user
   I want to go to the homepage
   So that I can see the solution of my procrastination problems

   Scenario: go to homepage
      Given I am not on the homepage
      When I go to the homepage
      Then I should see "Welcome to StartWork"
