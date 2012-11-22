Given /^there is an initiative$/ do
	@initiative = Initiative.find_or_create_by(:name => "Mijn initiatief", :location => "Mijn locatie", :description => "Mijn omschrijving")
end

#Given /^I follow the first initiative$/ do
#	click_link('Bekijk kalender') #Use only if there are multiple initiatives
#end

When /^I create a new initiative$/ do
  click_link('Nieuwe Bucket Line')
  fill_in("initiative_name", :with => "Mijn initiatief")
  fill_in("initiative_location", :with => "Mijn locatie")
  fill_in("initiative_description", :with => "Mijn omschrijving")
  click_button("Opslaan")
end

Then /^I should be an initiative admin$/ do
  UserRole.where(:user_id => @super_admin.id, :initiative_id => Initiative.last.id).count.should == 1
end

When /^I remove "(.*?)" from the initiative$/ do |arg1|
  click_link "Verwijderen"
end

Then /^"(.*?)" should not be an initiative member$/ do |arg1|
  @user = User.where(:email => arg1).first
  @initiative = Initiative.where(:name => "Mijn initiatief").first
  UserRole.where(:user_id => @user.id, :initiative_id => @initiative.id).count.should == 0
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

Then /^I should see the initiative properties$/ do
  page.should have_content("Naam: Mijn initiatief")
  page.should have_content("Omschrijving: Mijn omschrijving")
  page.should have_content("Locatie: Mijn locatie")
  page.should have_content("Bucket Line beheerders: ")
  page.should have_content("Bucket Line leden: User")
  page.should have_content("Schrijf mij uit bij deze Bucket Line")
end

Then /^I should see both initiatives$/ do
  page.should have_content("Mijn eerste initiatief")
  page.should have_content("Mijn tweede initiatief")
end

Then /^I should see the right initiative permissions for the initiative user$/ do
  page.should have_content("Mijn initiatief")
  page.should have_content("Mijn profiel")
  page.should have_content("Mijn bijdragen")
  page.should have_content("Instellingen")
  page.should have_content("Kalender")
  page.should have_content("Verlanglijstje")
  page.should have_content("Mijn beschikbaarheid")
  page.should have_content("Over deze Bucket Line")
  page.should_not have_content("Nieuwe Klus")
  page.should_not have_content("Bucket Line instellingen")
  page.should_not have_content("Deelnemers beheer")
  page.should_not have_content("Alle beschikbaarheid")
  page.should_not have_content("Alle bijdragen")
  page.should_not have_content("Applicatie beheer")
  page.should_not have_content("Alle bucket lines")
  page.should_not have_content("Feedback berichten")
  page.should_not have_content("Alle gebruikers")
end

Then /^I should see the right initiative permissions for the initiative admin$/ do
  page.should have_content("Mijn initiatief")
  page.should have_content("Mijn profiel")
  page.should have_content("Mijn bijdragen")
  page.should have_content("Instellingen")
  page.should have_content("Kalender")
  page.should have_content("Verlanglijstje")
  page.should have_content("Mijn beschikbaarheid")
  page.should have_content("Over deze Bucket Line")
  page.should have_content("Alle bijdragen")
  page.should have_content("Nieuwe Klus")
  page.should have_content("Bucket Line instellingen")
  page.should have_content("Deelnemers beheer")
  page.should have_content("Alle beschikbaarheid")
  page.should_not have_content("Applicatie beheer")
  page.should_not have_content("Alle bucket lines")
  page.should_not have_content("Feedback berichten")
  page.should_not have_content("Alle gebruikers")
end

Then /^I should see the right initiative permissions for the super admin$/ do
  #Super admin is not a member of any initiative, so initiative options are not shown
  page.should have_content("Mijn profiel")
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
  check "user_role_admin"
  click_button "Update"
end

Then /^the intitiative user should be initiative admin$/ do
  UserRole.where(:initiative_id => @initiative.id, :user_id => @user.id, :admin => true).count.should == 1
end

Then /^"(.*?)" should be an initiative member$/ do |email|
  user = User.where(:email => email).first
  UserRole.where(:initiative_id => @initiative.id, :user_id => user.id, :admin => false).count.should == 1
end

