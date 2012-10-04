Feature: Create initiative and invite new members
	In order to create social capital before the start of my initiative
	As a user
	I want to create an initiative and invite members

	Scenario: User creates initiative and becomes inititative administrator
		Given I am logged in as a super admin
		And I am on the initiatives page
		When I create a new initiative
		Then I should be an initiative admin 

	@wip
	Scenario: Initiative administrator invites new member
		Given there is an initiative
		And I am logged in as an initiative admin
		And I am on the only initiatives' projects page
		When I follow "Deelnemers beheren"
		And I follow "Nieuwe gebruiker uitnodigen"
		And I fill in the form with a new invitation
		Then the new user should get an invitation for the initiative


	Scenario: Initiative administrator removes member

	Scenario: Member leaves initiative 