When /^I submit the form with a new invitation$/ do
	fill_in "user_email", :with => "initiative_user@test.com"
	click_button "Verstuur een uitnodiging"
end

When /^the user accepts the invitation$/ do
	step %(I open the email)
	step %(I follow "Uitnodiging accepteren" in the email)
end
