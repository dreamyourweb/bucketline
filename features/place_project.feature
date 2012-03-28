Feature: Place a new question
	In order to get things done
	As a user
	I want to place a new question

	Background:
		Given I am a user
		And I am logged in

	Scenario: Receive instructions
		When I go to the questions page
		Then I should see "Plaats een zo gedetailleerd mogelijke vraag"

	Scenario: Place new question
		When I go to the questions page
		And I follow "Nieuwe vraag om materiaal"
		And I fill in query with "Wie heeft er een fundering over?"
		And I add an item "Stoeptegels"
		And I follow "Voeg item toe"
		And I add an item "Beton"
		And I press "Plaats deze vraag"
		Then I should see "De vraag is geplaatst"
		And I should see "Wie heeft er een fundering over?"
		And I click on the question
		And I should see "Stoeptegels"
		And I should see "Beton" 
