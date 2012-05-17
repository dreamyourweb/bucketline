Feature: get email notifications
	In order to be reminded of important activities
	As a person related to the project
	I want to receive email notifications on critical moments

	Scenario: receive notifications on upcoming date for contribution
		Given I am a user with email "karel@test.com"
		And I provided an item for tomorrow
		When it is time for a reminder
		Then I should receive an email notification on "karel@test.com"

	Scenario: receive notification when a project is placed on one of my available dates
		Given I am logged in as a user
		And I am available for tomorrow
		When the admin plans a project for tomorrow
		Then I should receive an email notification on "user@test.com"

	Scenario: receive notification when a new user is registered
		Given I am logged in as an admin
		When a new user is registered
		Then I should receive an email notification on "admin@test.com"
