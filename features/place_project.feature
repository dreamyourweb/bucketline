Feature: Place a new project
	In order to get things done
	As an admin
	I want to place a new project

	Background:
		Given I am logged in as an admin

	Scenario: Place new project
		When I go to the calendar page
		And I follow "Plaats nieuw project"
		And I fill in the form with a project and an item
		And I press "Create Project"
		Then I should see my project
