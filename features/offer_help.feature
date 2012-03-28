Feature: User offers help
	In order to add value to a project 
	As a user
	I want to be able to help

	Background:
		Given I am logged in as a user named "Piet"

	Scenario: View all the projects
		When I go to the projects page
		Then I should see all the projects

	Scenario: View the calendar
		When I go to the calendar page
		Then I should see all the projects

	Scenario: Mark item as provided
		When I go to the projects page
		And I click on a project
		And I provide 1 item
		Then I should see "Gegeven door Piet"

	Scenario: Announce my availability for a specific date
		When I go to my profile page
		And register my availability for a specific date
		Then I should see my registration
