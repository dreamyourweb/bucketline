When /^I change my experise$/ do
	fill_in("profile_expertise", :with => "Taarten bakken")
end

Then /^I should see my new expertise$/ do
	save_and_open_page
	page.should have_content("Taarten bakken")
end

Then /^I should see my registration$/ do
	page.should have_content("User - Hard werken")
end

Then /^I should see my relevant profile fields$/ do
	page.should have_content("Naam")
	page.should have_content("Ik ben goed in")
	page.should have_content("Ik kan helpen met")
	page.should have_content("Ik kan de volgende gereedschappen en materialen inbrengen")
	page.should have_content("Stuur mij een herinnerings-email")
	page.should have_content("Stuur mij een email als er een nieuw project gepland wordt")
	page.should have_content("Stuur mij een email als een project waaraan ik bijdraag wordt geannuleerd")
end
