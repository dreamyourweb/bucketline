Feature: Admin invites new user to join initiative
	In order to expand my social capital
	As an admin
	I want to invite a user to join my initiative

	Background:
		Given there is an initiative
		And I am logged in as an initiative admin

	Scenario: Admin invites new user
		Given no emails have been sent
		When I go to the manage users page
		And I follow "Nieuwe Uitnodiging"
		And I submit the form with a new invitation
		Then "initiative_user@test.com" should receive 1 email
		When I log out
		And the user accepts the invitation
		Then "initiative_user@test.com" should be an initiative member

	Scenario: Admin invites existing user
		Given there is a user
		And no emails have been sent
		When I go to the manage users page
		And I follow "Nieuwe Uitnodiging"
		And I submit the form with a new invitation
		Then "initiative_user@test.com" should receive 1 email
		When I log out
		And the user accepts the invitation
		Then "initiative_user@test.com" should be an initiative member

	Scenario: User gets invited to two initiatives
		#Faces a problem, because after an accepted invite for a second initiative, the users password becomes corrupted somehow, eventhough it still has the same encrypted string.