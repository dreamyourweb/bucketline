Feature: view availability of specialists
	In order to schedule my activities efficiëntly
	As an admin
	I want to view the availability of my specialists over time

	Background:
		Given there is an initiative
		And I am logged in as an initiative admin
		And a specialist "Frans" with email "frans@test.com" and expertise "Bakker" who provided his availability 
		And I am on the initiatives page
		And I follow the first initiative

	Scenario: View available specialists
		When I follow "Admin"
		And I follow "Beschikbare specialisten"
		Then I should see "frans@test.com"
