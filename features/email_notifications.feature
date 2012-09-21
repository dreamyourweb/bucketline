Feature: get email notifications
	In order to be reminded of important activities
	As a person related to the project
	I want to receive email notifications on critical moments

	Scenario: receive notification when a project is placed
		Given I am logged in as a user
		And no emails have been sent
		When I log out
		And the admin logs in
		And the admin plans a project for tomorrow
		And the admin logs out
		Then "user@test.com" should receive 1 email from "admin@test.com"

	Scenario: receive notification when a loose item is placed
		Given I am logged in as a user
		And no emails have been sent
		When I log out
		And the admin logs in
		And the admin places a loose item
		And the admin logs out
		And the system does it's automated tasks
		Then "user@test.com" should receive 1 email from "no-reply@waardeverbinder.nl"

	Scenario: receive notification when a contribution is made
		Given I have contributed to a project
		Then "admin@test.com" should receive 1 email

	Scenario: receive notification when a contribution is cancelled
		Given I have contributed to a project
		And no emails have been sent
		When I retreat my contribution
		Then "admin@test.com" should receive 1 email

	Scenario: receive notification when a project I provided for is cancelled
		Given I have contributed to a project
		And no emails have been sent
		When the admin logs in via the login screen
		And the admin cancels the project
		Then "user@test.com" should receive 1 email from "admin@test.com"

	Scenario: receive notification when a loose item I provided for is cancelled
		Given I have contributed to a loose item
		And no emails have been sent
		When the admin logs in via the login screen
		And the admin cancels the item
		Then "user@test.com" should receive 1 email from "admin@test.com"

	Scenario: receive notification when a project I provided for is edited
		Given I have contributed to a project
		And no emails have been sent
		When the admin logs in via the login screen
		And the admin edits the project
		Then "user@test.com" should receive 1 email from "admin@test.com"

	Scenario: receive notification when a new user is registered
		Given an admin with email "admin@test.com"
		And a clear email queue
		When a new user is registered
		Then "admin@test.com" should receive 1 email

	Scenario: send reminders
		Given I am logged in as a user
		And there is a project with an item
		And a clear email queue
 		When I provide an item via the calendar page
		And the system does it's automated tasks
		Then "user@test.com" should receive 1 email 
