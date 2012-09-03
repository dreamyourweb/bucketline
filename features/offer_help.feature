Feature: User offers help
	In order to add value to a project 
	As a user
	I want to be able to help

	Background:
		Given I am logged in as a user
		And there is an initiative with a project and an item
		And I am on the initiatives page
		And I follow the first initiative

	Scenario: View all the projects
		When I go to the calendar
		Then I should see all the projects

	Scenario: View all the items
		When I go to the dashboard
		Then I should see all the items

	Scenario: Mark item as provided via dashboard
		When I go to the dashboard
		And I provide 1 item
		And I go to the dashboard
		Then I should see "User"

	Scenario: Mark item as provided via calender
		When I go to the calendar
		And I click on a project
		And I provide 1 item
		And I click on a project
		Then I should see "Bijdragers zijn: User"

	Scenario: Retreat help
		When I go to the dashboard
		And I provide 1 item
		And I follow "Mijn profiel"
		Then I should see "Mijn item"
		When I follow "bijdrage intrekken"
		Then I should not see "Mijn item"		
