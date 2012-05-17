Given /^I am a user with email "([^"]*)"$/ do |arg1|
  @user = User.find_or_create_by(:email => arg1, :password => 'foobar', :password_confirmation => 'foobar')
	@user.profile.update_attributes(:name => "Karel")
end

Given /^I provided an item for tomorrow$/ do
	@project = Project.create(:query => "Mijn project", :start_at => Date.tomorrow, :end_at => Date.tomorrow, :daypart => ["Middag", "Avond"])
	@item = @project.items.create(:name => "Mijn item", :type => "help", :amount => 1, :start_at => Date.tomorrow, :end_at => Date.tomorrow, :daypart => ["Middag", "Avond"])
end

Given /^I am available for tomorrow$/ do
	@user.profile.available_dates.create(:date => Date.tomorrow, :daypart => ["Middag", "Avond"])
end

When /^the admin plans a project for tomorrow$/ do
	%("Given I am logged out")
	%("Given I am logged in as an admin")
	click_link('Project kalender')
	click_link('Plaats nieuw project')
  fill_in("project_query", :with => "Mijn project")
	select("Middag", :from => "project_daypart")
	select_date(Date.tomorrow.to_s, :from => "project_Begin", :order => [:year, :month, :day])
	select_date(Date.tomorrow.to_s, :from => "project_Einde", :order => [:year, :month, :day])
	click_button("Create Project")
	click_link('logout')	
end

Given /^(?:a clear email queue|no emails have been sent)$/ do
  reset_mailer
end

Then /^"([^']*?)" should receive (\d+) emails?$/ do |address, n|
  unread_emails_for(address).size.should == n.to_i
end

