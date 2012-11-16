Feature: get email notifications
	In order to be reminded of important activities
	As a person related to a project
	I want to receive email notifications on critical moments

	Background:
		Given there is an initiative
		#And I am on the only initiatives' projects page

	Scenario: receive notification when a project is placed
		Given I am logged in as an initiative user
		And no emails have been sent
		When I log out
		And the initiative admin logs in
		And the initiative admin plans a project for tomorrow
		And the initiative admin logs out
		Then "initiative_user@test.com" should receive 1 email from "initiative_admin@test.com"

	Scenario: receive notification when a loose item is placed
		Given I am logged in as an initiative user
		And no emails have been sent
		When I log out
		And the initiative admin logs in
		And the initiative admin places a loose item
		And the initiative admin logs out
		And the system sends the item placement mail
		Then "initiative_user@test.com" should receive 1 email

	Scenario: receive notification when a contribution is made
		Given no emails have been sent
		And I have contributed to a project
		Then "initiative_admin@test.com" should receive 1 email

	Scenario: receive notification when a contribution is cancelled
		Given I have contributed to a project
		And no emails have been sent
		When I follow "Mijn project"
		And I retreat my contribution
		Then "initiative_admin@test.com" should receive 1 email

	Scenario: receive notification when a project I provided for is cancelled
		Given I have contributed to a project
		And no emails have been sent
		When I log out
		And the initiative admin logs in via the login screen
		And the initiative admin cancels the project
		Then "initiative_user@test.com" should receive 1 email from "initiative_admin@test.com"

	Scenario: receive notification when a loose item I provided for is cancelled
		Given I have contributed to a loose item
		And no emails have been sent
		When I log out
		And the initiative admin logs in via the login screen
		And the initiative admin cancels the item
		Then "initiative_user@test.com" should receive 1 email from "initiative_admin@test.com"

	Scenario: receive notification when a project I provided for is edited
		Given I have contributed to a project
		And no emails have been sent
		When I log out
		And the initiative admin logs in via the login screen
		And the initiative admin edits the project
		Then "initiative_user@test.com" should receive 1 email from "initiative_admin@test.com"

	Scenario: receive notification when a new user is registered
		Given I am logged in as an initiative admin
		And a clear email queue
		When a new user is registered on the initiative
		Then "initiative_admin@test.com" should receive 1 email

	@wip
	Scenario: send reminders
		Given I am logged in as an initiative user
		And there is a project with an item
		And a clear email queue
 		When I provide an item via the calendar page
		And the system sends the reminders
		Then "initiative_user@test.com" should receive 1 email 
