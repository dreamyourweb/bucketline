When /^I change my experise$/ do
	fill_in("profile_expertise", :with => "Taarten bakken")
end

Then /^I should see my new expertise$/ do
	page.should have_content("Taarten bakken")
end

When /^register my availability for a specific date$/ do
	click_link "Beschikbaarheid bewerken"
	press "Update Profile"
end

Then /^I should see my registration$/ do
	page.should have_content("Frans - Bakker")
end
