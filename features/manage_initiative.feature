Feature: Manage initiative and invite new members
	In order to create social capital before the start of my initiative
	As an initiative admin
	I want to create an initiative and invite members

	Scenario: User creates initiative and becomes inititative administrator
		Given I am logged in as a super admin
		And I am on the initiatives page
		When I create a new initiative
		Then I should be an initiative admin 

	Scenario: Initiative administrator removes member
		Given there is an initiative
		And there is an initiative user
		And I am logged in as an initiative admin
		When I follow "Deelnemers beheer"
		And I remove "initiative_user@test.com" from the initiative
		Then "initiative_user@test.com" should not be an initiative member

	Scenario: Member leaves initiative
		Given there is an initiative
		And I am logged in as an initiative user
		When I follow "Over deze Bucket Line"
		And I follow "Schrijf mij uit bij deze Bucket Line"
		Then "initiative_user@test.com" should not be an initiative member

	Scenario: initiative is deleted
		Given there is an initiative
		And I am logged in as a super admin
		And I am on the initiatives page
		When I follow "Verwijderen"
		Then there should be no initiatives

	@wip
	Scenario: Initiative name is changed
		Given there is an initiative
		And I am logged in as an initiative admin
		When I follow "Bucket Line instellingen"
		And I update the Bucket Line settings
		Then I should see the new Bucket Line settings
		And the url should have the new Bucket Line slug
