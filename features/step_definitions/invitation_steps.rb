When /^I submit the form with a new invitation$/ do
	fill_in "user_email", :with => "initiative_user@test.com"
	click_button "Verstuur een uitnodiging"
end

When /^the user accepts the invitation$/ do
  pending # express the regexp above with the code you wish you had
end
