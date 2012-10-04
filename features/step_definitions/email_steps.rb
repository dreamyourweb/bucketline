Given /^I provided an item for tomorrow$/ do
	@project = Project.find_or_create_by(:query => "Mijn project", :start_at => Date.tomorrow, :end_at => Date.tomorrow, :daypart => ["Middag", "Avond"])
	@item = @project.items.create(:name => "Mijn item", :type => "help", :amount => 1, :start_at => Date.tomorrow, :end_at => Date.tomorrow, :daypart => ["Middag", "Avond"])
end

Given /^I am available for tomorrow$/ do
	@user.profile.available_dates.create(:date => Date.tomorrow, :daypart => ["Middag", "Avond"])
end

Given /^(?:a clear email queue|no emails have been sent)$/ do
  reset_mailer
end

Then /^"([^']*?)" should receive (\d+) emails?$/ do |address, n|
  unread_emails_for(address).size.should == n.to_i
end

When /^I open the email$/ do
  open_email(current_email_address)
end

When /^the system sends the reminders$/ do    
  require "rake"
  @rake = Rake::Application.new
  Rake.application = @rake
  Rake.application.rake_require "tasks/scheduler"
  Rake::Task.define_task(:environment)
  @rake['send_reminders'].invoke   
end

When /^the system sends the item placement mail$/ do    
  require "rake"
  @rake = Rake::Application.new
  Rake.application = @rake
  Rake.application.rake_require "tasks/scheduler"
  Rake::Task.define_task(:environment)
  @rake['send_item_placement_mail'].invoke   
end

Then /^"([^']*?)" should receive (\d+) emails? from "([^']*?)"$/ do |address, n, sender|
  unread_emails_for(address).size.should == n.to_i
	unread_emails_for(address).first.should be_delivered_from(sender)
end

Given /^I am an initiative user with email "([^"]*)"$/ do |arg1|
  @user = User.find_or_create_by(:email => arg1, :password => 'foobar', :password_confirmation => 'foobar')
  @user.user_roles.create(:initiative_id => @initiative.id)
  @user.profile.update_attributes(:name => "Karel")
end

