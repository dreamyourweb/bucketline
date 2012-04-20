When /^I change my experise$/ do
	fill_in("profile_expertise", :with => "Taarten bakken")
end

Then /^I should see my new expertise$/ do
	page.should have_content("Taarten bakken")
end

Then /^I should see my registration$/ do
	page.should have_content("User - Hard werken")
end

Then /^I should see my relevant profile fields$/ do
	page.should have_content("Naam")
	page.should have_content("Waar ben je goed in?")
	page.should have_content("Ik kan helpen met...")
	page.should have_content("Ik kan de volgende gereedschappen en materialen inbrengen...")
end
