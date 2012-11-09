Feature: Initiative admin appoints fellow admin
	In order to get help coordinating my initiative
	As an initiative admin
	I want to appoint a fellow initiative admin

	@wip
	Scenario: Initiative admin appoints a fellow initiative admin
		Given there is an initiative
		And there is an initiative user
		And I am logged in as an initiative admin
		And no emails have been sent
		When I go to the manage users page
		And I promote the initiative user to initiative admin
		Then the intitiative user should be initiative admin
		And "initiative_user@test.com" should receive 1 email