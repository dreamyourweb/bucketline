Feature: Update profile
	In order to allow the admins to schedule activities more efficiëntly
	As a user
	I want to keep my personal data, expertise and availability up to date

	Background:
		Given I am logged in as a user

	Scenario: Announce my availability for a specific date
		When I go to my profile page
		And register my availability for a specific date
		Then I should see my registration

	Scenario: Edit my expertise
		When I go to my profile page
		And I follow "Mijn profiel bewerken"
		And change my experise
		Then I should see my new expertise
