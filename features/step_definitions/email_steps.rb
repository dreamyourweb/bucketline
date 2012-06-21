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
	click_link('Project kalender')
	click_link('Plaats nieuw project')
	fill_in("project_query", :with => "Mijn project")
	select("Middag", :from => "project_daypart")
	select(Date.tomorrow.day.to_s, :from => "project_start_at_3i")
	select(I18n.t("date.month_names")[Date.tomorrow.month], :from => "project_start_at_2i")
	select(Date.tomorrow.year.to_s, :from => "project_start_at_1i")
	select(Date.tomorrow.day.to_s, :from => "project_end_at_3i")
	select(I18n.t("date.month_names")[Date.tomorrow.month], :from => "project_end_at_2i")
	select(Date.tomorrow.year.to_s, :from => "project_end_at_1i")
	click_button("Project en items opslaan")
	visit("/logout")
end

Given /^(?:a clear email queue|no emails have been sent)$/ do
  reset_mailer
end

Then /^"([^']*?)" should receive (\d+) emails?$/ do |address, n|
  unread_emails_for(address).size.should == n.to_i
end

Then /^"([^']*?)" should receive (\d+) emails? from "([^']*?)"$/ do |address, n, sender|
  unread_emails_for(address).size.should == n.to_i
	unread_emails_for(address).first.should be_delivered_from(sender)
end

