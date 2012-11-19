When /^I submit the form with a new invitation$/ do
	fill_in "user_email", :with => "initiative_user@test.com"
	click_button "Verstuur een uitnodiging"
end

When /^the user accepts the invitation$/ do
	open_email("initiative_user@test.com")
	step %(I follow "Uitnodiging accepteren" in the email)
end

When /^I invite the user to "(.*?)"$/ do |initiative|
	click_link initiative
	click_link "Deelnemers beheer"
	click_link "Nieuwe Uitnodiging"
	step %(I submit the form with a new invitation)
end

