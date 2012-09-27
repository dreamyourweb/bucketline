Given /^there is an initiative$/ do
	@initiative = Initiative.find_or_create_by(:name => "Mijn initiatief", :location => "Mijn locatie", :description => "Mijn omschrijving")
end

Given /^I follow the first initiative$/ do
	click_link('Bekijk initiatief')
end

When /^a new user is registered on the initiative$/ do
	@user.user_roles.create(:initiative_id => @initiative.id)
end