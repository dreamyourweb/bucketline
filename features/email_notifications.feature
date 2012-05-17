Feature: get email notifications
	In order to be reminded of important activities
	As a person related to the project
	I want to receive email notifications on critical moments

	Background:
		Given a clear email queue

	Scenario: receive notification when a project is placed on one of my available dates
		Given I am logged in as a user
		And I am available for tomorrow
		When the admin plans a project for tomorrow
		Then "user@test.com" should receive 1 email

	Scenario: receive notification when a new user is registered
		Given I am logged in as an admin
		When a new user is registered
		Then "admin@test.com" should receive 1 email
