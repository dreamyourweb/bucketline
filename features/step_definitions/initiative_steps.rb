Given /^there is an initiative$/ do
	@initiative = Initiative.find_or_create_by(:name => "Mijn initiatief", :location => "Mijn locatie", :description => "Mijn omschrijving")
end

#Given /^I follow the first initiative$/ do
#	click_link('Bekijk kalender') #Use only if there are multiple initiatives
#end

When /^I create a new initiative$/ do
  click_link('Nieuwe Bucket Line aanmaken')
  fill_in("initiative_name", :with => "Mijn initiatief")
  fill_in("initiative_location", :with => "Mijn locatie")
  fill_in("initiative_description", :with => "Mijn omschrijving")
  click_button("Bucket Line aanmaken")
end

Then /^I should be an initiative admin$/ do
  UserRole.where(:user_id => @super_admin.id, :initiative_id => Initiative.last.id).count.should == 1
end

When /^a new user is registered on the initiative$/ do
	@new_user = User.create(:email => 'initiative_user@test.com', :password => 'foobar', :password_confirmation => 'foobar', :name => "User")
	@new_user.update_attributes(:confirmed_at => Time.now)
	@new_user.user_roles.create(:initiative_id => @initiative.id)
end

Given /^there are two initiatives$/ do
	@first_initiative = Initiative.find_or_create_by(:name => "Mijn eerste initiatief", :location => "Mijn locatie", :description => "Mijn omschrijving")
	@second_initiative = Initiative.find_or_create_by(:name => "Mijn tweede initiatief", :location => "Mijn locatie", :description => "Mijn omschrijving")
end

Then /^I should see both initiatives$/ do
  page.should have_content("Mijn eerste initiatief")
  page.should have_content("Mijn tweede initiatief")
end

Then /^I should see the right initiative permissions for the initiative user$/ do
  page.should have_content("Mijn initiatief")
  page.should have_content("Profiel")
  page.should have_content("Mijn bijdragen")
  page.should have_content("Instellingen")
  page.should have_content("Kalender")
  page.should have_content("Verlanglijstje")
  page.should have_content("Mijn beschikbaarheid")
  page.should_not have_content("Plaats nieuwe klus")
  page.should_not have_content("Bucketline instellingen")
  page.should_not have_content("Deelnemers beheer")
  page.should_not have_content("Bucketline beschikbaarheid")
  page.should_not have_content("Bucketline bijdragen")
  page.should_not have_content("Applicatie beheer")
  page.should_not have_content("Alle bucket lines")
  page.should_not have_content("Feedback berichten")
  page.should_not have_content("Alle gebruikers")
end

Then /^I should see the right initiative permissions for the initiative admin$/ do
  page.should have_content("Mijn initiatief")
  page.should have_content("Profiel")
  page.should have_content("Mijn bijdragen")
  page.should have_content("Instellingen")
  page.should have_content("Kalender")
  page.should have_content("Verlanglijstje")
  page.should have_content("Mijn beschikbaarheid")
  page.should have_content("Bucketline bijdragen")
  page.should have_content("Plaats nieuwe klus")
  page.should have_content("Bucketline instellingen")
  page.should have_content("Deelnemers beheer")
  page.should have_content("Bucketline beschikbaarheid")
  page.should_not have_content("Applicatie beheer")
  page.should_not have_content("Alle bucket lines")
  page.should_not have_content("Feedback berichten")
  page.should_not have_content("Alle gebruikers")
end

Then /^I should see the right initiative permissions for the super admin$/ do
  #Super admin is not a member of any initiative, so initiative options are not shown
  page.should have_content("Profiel")
  page.should have_content("Mijn bijdragen")
  page.should have_content("Instellingen")

  page.should have_content("Applicatie beheer")
  page.should have_content("Alle bucket lines")
  page.should have_content("Feedback berichten")
  page.should have_content("Alle gebruikers")
end

Then /^I should only see the initiative I am a member of$/ do
	page.should have_content ("Mijn eerste initiatief")
	page.should_not have_content ("Mijn tweede initiatief")
end

When /^I promote the initiative user to initiative admin$/ do
  save_and_open_page
  check "user_role_admin"
  click_button "Update"
end

Then /^the intitiative user should be initiative admin$/ do
  UserRole.where(:initiative_id => @initiative.id, :user_id => @user.id, :admin => true).count.should == 1
end

Then /^"(.*?)" should be an initiative member$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

