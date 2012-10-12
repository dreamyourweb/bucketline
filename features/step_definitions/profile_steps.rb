When /^I change my experise$/ do
	fill_in("profile_expertise", :with => "Taarten bakken")
end

Then /^I should see my new expertise$/ do
	page.find_field("profile_expertise").value.should == "Taarten bakken"
end

Then /^I should see my registration$/ do
	page.should have_content("User - Hard werken")
end

Then /^I should see my relevant profile fields$/ do
	page.should have_content("Ik ben goed in")
	page.should have_content("Ik kan helpen met")
	page.should have_content("Ik kan de volgende gereedschappen en materialen inbrengen")
	page.should have_content("Stuur mij een herinnerings-email")
	page.should have_content("Stuur mij een email als er een nieuwe klus of benodigdheid geplaatst wordt")
	page.should have_content("Stuur mij een email als een klus of benodigdheid waaraan ik bijdraag wordt geannuleerd of gewijzigd")
	page.should have_content("Stuur mij een email als mijn bevoegdheden in een Bucket Line wordt aangepast")
	page.should have_content("Ik ben bereid om buddy te worden als de nood aan de man is")
end

Then /^the initiative user should be purged from the system$/ do
	User.where(:name => "User").all.count.should == 0
end

Then /^the initiative admin should be purged from the system$/ do
	User.where(:name => "Admin").all.count.should == 0
end
