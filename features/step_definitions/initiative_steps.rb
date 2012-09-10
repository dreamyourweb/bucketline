Given /^there is an initiative$/ do
	@initiative = Initiative.create(:name => "Mijn initiatief", :location => "Mijn locatie", :description => "Mijn omschrijving")
end

Given /^I follow the first initiative$/ do
	click_link('Bekijk initiatief')
end
