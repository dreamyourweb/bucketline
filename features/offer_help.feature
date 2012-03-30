Feature: User offers help
	In order to add value to a project 
	As a user
	I want to be able to help

	Background:
		Given I am logged in as a user
		And there is a project with an item

	Scenario: View all the projects
		When I go to the calendar page
		Then I should see all the projects

	Scenario: View all the items
		When I go to the dashboard page
		Then I should see all the items

	Scenario: Mark item as provided via dashboard
		When I go to the dashboard page
		And I provide 1 item
		Then I should see "Gegeven door User"

	Scenario: Mark item as provided via calender
		When I go to the calendar page
		And I click on a project
		And I provide 1 item
		Then I should see "Gegeven door User"

	@wip
	Scenario: Announce my availability for a specific date
		When I go to my profile page
		And register my availability for a specific date
		Then I should see my registration
