Given /^there is an initiative$/ do
	@initiative = Initiative.find_or_create_by(:name => "Mijn initiatief", :location => "Mijn locatie", :description => "Mijn omschrijving")
end

Given /^I follow the first initiative$/ do
	click_link('Bekijk initiatief') #Use only if there are multiple initiatives
end

When /^a new user is registered on the initiative$/ do
	@new_user = User.create(:email => 'initiative_user@test.com', :password => 'foobar', :password_confirmation => 'foobar', :name => "User")
	@new_user.update_attributes(:confirmed_at => Time.now)
	@new_user.user_roles.create(:initiative_id => @initiative.id)
end