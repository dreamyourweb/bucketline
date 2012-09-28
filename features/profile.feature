Feature: Update profile
	In order to allow the admins to schedule activities more efficiëntly
	As a user
	I want to keep my personal data, expertise and availability up to date

	Background:
		Given there is an initiative
		And I am logged in as an initiative user
		And I am on the only initiatives' projects page
		When I follow "Mijn profiel"

	Scenario: Relevant profile fields
		Then I should see my relevant profile fields

	Scenario: Edit my expertise
		And I change my experise
		And I press "Profiel opslaan"
		Then I should see my new expertise

	Scenario: User cancels account
		And I follow "Verwijder mijn account"
		Then the initiative user should be purged from the system 

	Scenario: Admin cancels account
		And I follow "Verwijder mijn account"
		Then the initiative admin should be purged from the system
