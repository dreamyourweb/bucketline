Feature: Admin invites new user to join initiative
	In order to expand my social capital
	As an admin
	I want to invite a user to join my initiative

	Background:

	Scenario: Admin invites new user
		Given there is an initiative
		And I am logged in as an initiative admin
		And no emails have been sent
		When I go to the manage users page
		And I follow "Nieuwe Uitnodiging"
		And I submit the form with a new invitation
		Then "initiative_user@test.com" should receive 1 email
		When I log out
		And the user accepts the invitation
		Then "initiative_user@test.com" should be an initiative member

	Scenario: Admin invites existing user
		Given there is an initiative
		And I am logged in as an initiative admin
		And there is a user
		And no emails have been sent
		When I go to the manage users page
		And I follow "Nieuwe Uitnodiging"
		And I submit the form with a new invitation
		Then "initiative_user@test.com" should receive 1 email
		When I log out
		And the user accepts the invitation
		Then "initiative_user@test.com" should be an initiative member

	@wip	
	Scenario: User gets invited to two initiatives
		Given there are two initiatives
		And I am logged in as an initiative admin for both initiatives
		And no emails have been sent
		When I invite the user to "Mijn eerste initiatief"
		And I log out
		And the user accepts the invitation
		And the user sets his password
		When I log out
		Then the user should be able to log in
		When I log out
		And the initiative admin logs in via the login screen
		Given no emails have been sent
		When I invite the user to "Mijn tweede initiatief" 
		And the user accepts the invitation
		And I log out
		Then the user should be able to log in

		#Faces a problem, because after an accepted invite for a second initiative, the users password becomes corrupted somehow, eventhough it still has the same encrypted string.