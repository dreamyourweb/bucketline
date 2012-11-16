Feature: view availability of specialists
	In order to schedule my activities efficiëntly
	As an admin
	I want to view the availability of my specialists over time

	Background:
		Given there is an initiative
		And I am logged in as an initiative admin
		And a specialist "Frans" with email "frans@test.com" and expertise "Bakker" who provided his availability 

	Scenario: View available specialists
		When I follow "Alle beschikbaarheid"
		Then I should see "frans@test.com"
