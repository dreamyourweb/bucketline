
	Scenario: Announce my availability for a specific date
		When I go to my profile page
		And register my availability for a specific date
		Then I should see my registration

	Scenario: Edit my profile
		When I go to my profile page
		And change my experise
		Then I should see my new expertise
