Feature: User signs in
  As a user
  I want to sign up and sign in
  so that I can use my protected profile


 Scenario: Facebook User signs in the first time
   Given a facebook user "Ben"
   When the user hits the facebook button
   Then the user sees "schön, dass du bei uns mitmachst!"

 Scenario: Facebook User signs in the first time
   Given a logged-in facebook user "Ben"
   Then the user sees "schön, dass du bei uns mitmachst!"

 Scenario: Facebook User signs in the first time and logs out
   Given a logged-in facebook user "Ben"
   When the user hits "Log out"
   Then the user sees "Curiosity is the driver of learning"

 Scenario: returning facebook user signs in 
   Given an already registered facebook user "Ben"
   When the user hits the facebook button
   Then the user sees "Maintain work sessions"

 Scenario: Facebook User (having one friend) signs in the first time
   Given a facebook user "Ben"
   And his facebook friend "Robert"
   When the user hits the facebook button
   Then the user sees "schön, dass du bei uns mitmachst!"
   And user "Ben" is created
   And user "Robert" is created
   And user "Ben" is friend with user "Robert"
   And user "Robert" is friend with user "Ben"

 Scenario: Facebook User (having two friends) signs in the first time
   Given a facebook user "Ben" and his friends "Robert, Miro"
   When the user hits the facebook button
   Then the user sees "schön, dass du bei uns mitmachst!"
   And user "Ben" is created
   And user "Robert" is created
   And user "Miro" is created
   And user "Ben" is friend with user "Robert"
   And user "Robert" is friend with user "Ben"
   And user "Ben" is friend with user "Miro"
   And user "Miro" is friend with user "Ben"


 Scenario: Facebook User (having one friend) signs in the first time
   Given a facebook user "Ben"
   And his facebook friend "Robert"
   When the user hits the facebook button
   And the user hits "Log out"
   And the user "Robert" hits the facebook button

 Scenario: Facebook User (having one not registered friend) signs in the first time and does not see his friend
   Given a facebook user "Ben"
   And his facebook friend "Robert"
   When the user hits the facebook button
   Then the user does not see "Wir haben gesehen, dass schon ein paar deiner Freunde dabei sind"
   And the user does not see "Robert"


 Scenario: Facebook User (having one registered friend) signs in the first time and does see his friend
   Given a facebook user "Ben" and his registered friends "Robert"
   When the user hits the facebook button
   Then the user sees "Wir haben gesehen, dass schon ein paar deiner Freunde dabei sind"
   And the user sees "Robert"

 Scenario: Facebook User (having two registered friends) signs in the first time and does see his friends
   Given a facebook user "Ben" and his registered friends "Robert, Miro"
   When the user hits the facebook button
   Then the user sees "Wir haben gesehen, dass schon ein paar deiner Freunde dabei sind"
   And the user sees "Robert"
   And the user sees "Miro"



# #@javascript
# Scenario: User signs in
#   Given the user with name "Ben", email "ben@example.com" and password "secret"
#   When the user signs in with his email "ben@example.com" and password "secret"
#   Then the user sees "Maintain work sessions"


