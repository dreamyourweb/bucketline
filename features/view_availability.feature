Feature: view availability of specialists
	In order to schedule my activities efficiëntly
	As an admin
	I want to view the availability of my specialists over time

	Background:
		Given I am logged in as an admin
		And I am on the home page
		And a specialist "Frans" with email "frans@test.com" and expertise "Bakker" who provided his availability 

	@wip
	Scenario: View calendar
		When I follow "Beschikbaarheid van specialisten"
		Then I should see "Frans - Bakker"
		When I follow "Frans - Bakker"
		Then I should see "frans@test.com"
