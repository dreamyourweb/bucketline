Feature: Place a new project
	In order to get things done
	As an admin
	I want to manage the projects

	Background:
		Given I am logged in as an admin
		And there is an initiative
		And I am on the initiatives page
		And I follow the first initiative

	Scenario: Place new project
		When I go to the calendar
		And I follow "Plaats nieuw project"
		And I fill in the form with a project and an item
		And I press "Project en items opslaan"
		Then I should see my project

	Scenario: Deleting the project also removes contributions
		Given there is a project with an item
		When I go to the dashboard
		And I provide 1 item
		And I delete the project
		And I follow "Mijn profiel"
		Then I should not see "Mijn item"

	Scenario: Admin refuses contribution
		Given there is a project with an item
		When I go to the dashboard
		And I provide 1 item
		And I go to the admin contributions dashboard
		And I follow the project link
		Then I should see "Mijn item"		
		When I follow "bijdrage weigeren"
		Then I should not see "Mijn item"
