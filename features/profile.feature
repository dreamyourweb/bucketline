Feature: Update profile
	In order to allow the admins to schedule activities more efficiëntly
	As a user
	I want to keep my personal data, expertise and availability up to date

	Background:
		Given I am logged in as a user
		And there is an initiative
		And I am on the initiatives page
		When I follow the first initiative
		And I follow "Mijn profiel"

	Scenario: Relevant profile fields
		Then I should see my relevant profile fields

	Scenario: Edit my expertise
		And I change my experise
		And I press "Profiel opslaan"
		Then I should see my new expertise

	Scenario: User cancels account
		And I follow "Verwijder mijn account"
		Then the user should be purged from the system 

	Scenario: Admin cancels account
		And I follow "Verwijder mijn account"
		Then the admin should be purged from the system
