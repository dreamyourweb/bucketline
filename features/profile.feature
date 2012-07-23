Feature: Update profile
	In order to allow the admins to schedule activities more efficiëntly
	As a user
	I want to keep my personal data, expertise and availability up to date

	Background:
		Given I am logged in as a user
		And I am on the home page

	@wip
	Scenario: Edit my expertise
		When I follow "Mijn profiel"
		And I change my experise
		And I press "Profiel opslaan"
		Then I should see my new expertise

	Scenario: Relevant profile fields
		When I follow "Mijn profiel"
		Then I should see my relevant profile fields
