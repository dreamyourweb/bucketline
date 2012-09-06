Feature: Update profile
	In order to allow the admins to schedule activities more efficiëntly
	As a user
	I want to keep my personal data, expertise and availability up to date

	Scenario: Edit my expertise
		Given I am logged in as a user
		And I am on the home page
		When I follow "Mijn profiel"
		And I change my experise
		And I press "Profiel opslaan"
		Then I should see my new expertise

	Scenario: Relevant profile fields
		Given I am logged in as a user
		And I am on the home page
		When I follow "Mijn profiel"
		Then I should see my relevant profile fields

	Scenario: User cancels account
		Given I am logged in as a user
		And I am on the home page
		When I follow "Mijn profiel"
		And I follow "Verwijder mijn account"
		Then the user should be purged from the system 

	Scenario: Admin cancels account
		Given I am logged in as an admin
		And I am on the home page
		When I follow "Mijn profiel"
		And I follow "Verwijder mijn account"
		Then the admin should be purged from the system
