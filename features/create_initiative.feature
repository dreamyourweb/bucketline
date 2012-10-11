Feature: Create initiative and invite new members
	In order to create social capital before the start of my initiative
	As a user
	I want to create an initiative and invite members

	Scenario: User creates initiative and becomes inititative administrator
		Given I am logged in as a super admin
		And I am on the initiatives page
		When I create a new initiative
		Then I should be an initiative admin 

	Scenario: Initiative administrator removes member

	Scenario: Member leaves initiative 