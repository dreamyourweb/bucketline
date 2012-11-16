Feature: View and redirect from initiatives overview
	In order to help with multipe initiatives
	As an application user
	I want to have the right permissions

	Scenario: User has one initiative and is redirected
		Given there is an initiative
		And I am logged in as an initiative user
		Then I should be redirected directly to the project page

	Scenario: User has two initiatives and chooses between them
		Given there are two initiatives
		And I am logged in as an initiative user for both initiatives
		Then I should see both initiatives

	Scenario: User sees only the initiatives he is a member of
		Given there are two initiatives
		And I am logged in as an initiative user for only one of the two initiatives
		Then I should only see the initiative I am a member of

	Scenario: User views initiative
		Given there is an initiative
		And I am logged in as an initiative user
		When I follow "Over deze Bucket Line"
		Then I should see the initiative properties

	Scenario: User has the right permissions on an initiative
		Given there is an initiative
		And I am logged in as an initiative user
		Then I should see the right initiative permissions for the initiative user

	Scenario: Initiative admin has the right permissions on an initiative
		Given there is an initiative
		And I am logged in as an initiative admin
		Then I should see the right initiative permissions for the initiative admin

	Scenario: Super admin has the right permissions on an initiative
		Given there is an initiative
		And I am logged in as a super admin
		Then I should see the right initiative permissions for the super admin
