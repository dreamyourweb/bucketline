When /^I change my experise$/ do
	fill_in("profile_expertise", :with => "Taarten bakken")
end

Then /^I should see my new expertise$/ do
	page.should have_content("Taarten bakken")
end

Then /^I should see my registration$/ do
	page.should have_content("User - Hard werken")
end
