Feature: Update profile
	In order to allow the admins to schedule activities more efficiëntly
	As a user
	I want to keep my personal data, expertise and availability up to date

	Background:
		Given there is an initiative
		And I am on the initiatives page
		And I follow the first initiative

	Scenario: Edit my expertise
		Given I am logged in as a user
		When I follow "Mijn profiel"
		And I change my experise
		And I press "Profiel opslaan"
		Then I should see my new expertise

	Scenario: Relevant profile fields
		Given I am logged in as a user
		When I follow "Mijn profiel"
		Then I should see my relevant profile fields
