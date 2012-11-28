Feature: User offers help
	In order to add value to a project 
	As a user
	I want to be able to help

	Background:
		Given there is an initiative
		And I am logged in as an initiative user
		And there is a project with an item

	Scenario: View all the projects
		Then I should see all the projects

	Scenario: Mark item as provided via wishlist dashboard
		Given I have contributed to a loose item
		Then I should see "User"

	Scenario: Mark item as provided via calender
		When I provide an item via the calendar page
		And I click on a project
		Then I should see "User"

	Scenario: Retreat help via profile
		When I provide an item via the calendar page
		And I follow "Mijn bijdragen"
		Then I should see "Mijn item"
		When I retreat my contribution
		Then I should not see "Mijn item"

	Scenario: Retreat help via calendar
		When I provide an item via the calendar page
		And I click on a project
		And I retreat my contribution
		Then I should not see "Bijdragers zijn: User"
