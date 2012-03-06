Feature: Visitor offers help
	In order to add value to a project 
	As a visitor
	I want to be able to help

	Background:
		Given I am a visitor

	Scenario: View all the questions
		When I go to the questions page
		Then I should see all the questions

	Scenario: Mark item as provided
		When I go to the question page
		And I click on a question
		And I check an item
		And I fill in name with "Piet"
		Then I should see "Gegeven door Piet"
		And I should be able to leave a comment

	Scenario: Place a comment
		When I go to the question page
		And I click on a question
		And I fill in name with "Piet"
		And I fill in comment with "Mijn commentaar"
		And I click on "Plaats commentaar"
		Then I should see "Mijn commentaar"
		And I should see "Piet"
