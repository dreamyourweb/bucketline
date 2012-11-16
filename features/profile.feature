Feature: Update profile
	In order to allow the admins to schedule activities more efficiëntly
	As a user
	I want to keep my personal data, expertise and availability up to date

	Background:
		Given there is an initiative
		And I am logged in as an initiative user

	Scenario: Relevant profile fields
		When I follow "Mijn profiel"
		Then I should see my relevant profile fields

	Scenario: Edit my expertise
		When I follow "Mijn profiel"
		And I change my experise
		And I press "Profiel opslaan"
		Then I should see my new expertise

	Scenario: User cancels account
		When I follow "Instellingen"
		And I follow "Verwijder mijn volledige inschrijving bij Bucket Line"
		Then the initiative user should be purged from the system 

	Scenario: Admin cancels account
		When I follow "Instellingen"
		And I follow "Verwijder mijn volledige inschrijving bij Bucket Line"
		Then the initiative admin should be purged from the system
