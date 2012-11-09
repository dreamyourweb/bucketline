Feature: loose items for wishlist dashboard
	In order to get long term items that don't belong to a project
	As an admin
	I want to manage a wishlist

	Background:
		Given there is an initiative

	Scenario: Mark item as provided via wishlist dashboard
		Given there is a loose item
		And I am logged in as an initiative user
		#And I am on the only initiatives' projects page
		When I follow "Verlanglijstje"
		And I provide 1 item
		And I follow "Verlanglijstje"
		Then I should see "User"

	Scenario: Place loose item
		Given I am logged in as an initiative admin
		#And I am on the only initiatives' projects page
		When I follow "Verlanglijstje"
		And I follow "Plaats nieuw item op verlanglijstje"
		And I fill the form with a loose item
		Then I should see my new loose item

	Scenario: Loose items show up in admin dashboard 	 
