Given /^I am logged in as an admin$/ do
	step %{the admin logs in}
end

When /^the admin logs in$/ do
  @admin = User.find_or_create_by(:email => 'admin@test.com', :password => 'foobar', :password_confirmation => 'foobar', :name => "Admin")
	@admin.update_attributes(:admin => true, :confirmed_at => Time.now)
	#@admin.profile.update_attributes(:expertise => "Bier drinken")
	save_and_open_page
  login(@admin.email, 'foobar')
end

When /^the admin logs out$/ do
	visit("/logout")
end

Given /^I am a visitor$/ do
  step %(I am not authenticated)
end

Given /^an admin with email "([^"]*)"$/ do |arg1|
  @admin = User.find_or_create_by(:email => arg1, :password => 'foobar', :password_confirmation => 'foobar', :name => "Admin")
	@admin.update_attributes(:admin => true, :confirmed_at => Time.now)
end

Given /^I am logged in as a user$/ do
  @user = User.find_or_create_by(:email => 'user@test.com', :password => 'foobar', :password_confirmation => 'foobar', :name => "User")
	@user.update_attributes(:confirmed_at => Time.now)
	@user.profile.update_attributes(:expertise => "Hard werken")
  login(@user.email, 'foobar')
end

Given /^a specialist "([^"]*)" with email "([^"]*)" and expertise "([^"]*)" who provided his availability$/ do |name, email, expertise|
  @specialist = User.find_or_create_by(:email => email, :password => 'foobar', :password_confirmation => 'foobar', :name => name)
	@specialist.update_attributes(:confirmed_at => Time.now)
	if @specialist.profile.nil?
		@specialist.profile = Profile.new(:expertise => expertise)
	end
	@profile = @specialist.profile
	@available_date = @profile.available_dates.create!(:date => Date.today, :daypart => ["Middag"])
	@available_date.save
end

Given /^(?:I am not authenticated|I log out)$/ do
 	# Ensure at least:
  visit('/logout')
end

When /^a new user is registered$/ do
	visit new_user_registration_path
	register("random_new_user@test.com", "foobar", "Random User")
end

When /^the admin logs in via the login screen$/ do
	login("admin@test.com", "foobar")
end

def login(email, password)
  visit('/login')
  fill_in('user_email', :with => email)
  fill_in('user_password', :with => password)
  click_button('Inloggen')
end

def register(email, password, name)
  fill_in "user_name", :with => name
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  fill_in "user_password_confirmation", :with => password
  click_button "Registreren"
end
