Feature: New user shows interest
	In order to obtain a Bucket Line
	As a new user
	I want to show my interest

	Scenario: New user registers
		Given I am on the registrations page
		And no emails have been sent
		When I fill in the form with my registration
		Then "info@bucketline.nl" should receive 1 email