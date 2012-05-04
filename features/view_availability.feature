Feature: view availability of specialists
	In order to schedule my activities efficiëntly
	As an admin
	I want to view the availability of my specialists over time

	Background:
		Given I am logged in as an admin
		And I am on the home page
		And a specialist "Frans" with email "frans@test.com" and expertise "Bakker" who provided his availability 

	Scenario: View calendar
		When I follow "Beschikbaarheid specialisten"
		Then I should see "Frans"
		And I should see "Bakker"
		And I should see "frans@test.com"
