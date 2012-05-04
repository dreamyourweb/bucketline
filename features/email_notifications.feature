Feature: get email notifications
	In order to be reminded of important activities
	As a user
	I want to receive email notifications on critical moments

	Background:
		Given I am a user with email "karel@test.com"

	@wip
	Scenario: receive notifications on upcoming date for contribution
		Given I provided an item for tomorrow
		When it is time for a reminder
		Then I should receive an email notification on "karel@test.com"

	@wip
	Scenario: receive notification when a project is placed on one of my available dates
		Given I am available for tomorrow
		When the admin plans a project for tomorrow
		Then I should receive an email notification on "karel@test.com"
