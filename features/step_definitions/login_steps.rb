Given /^I am logged in as an admin$/ do
  @admin = User.find_or_create_by(:email => 'admin@test.com', :password => 'foobar', :password_confirmation => 'foobar')
	@admin.update_attributes(:admin => true, :confirmed_at => Time.now)
	@admin.profile.update_attributes(:name => "Admin", :expertise => "Bier drinken")
  login(@admin.email, 'foobar')
end

Given /^I am a visitor$/ do
  step %(I am not authenticated)
end

Given /^I am logged in as a user$/ do
  @user = User.find_or_create_by(:email => 'user@test.com', :password => 'foobar', :password_confirmation => 'foobar')
	@user.update_attributes(:confirmed_at => Time.now)
	@user.profile.update_attributes(:name => "User", :expertise => "Hard werken")
  login(@user.email, 'foobar')
end

Given /^a specialist "([^"]*)" with email "([^"]*)" and expertise "([^"]*)" who provided his availability$/ do |name, email, expertise|
  @specialist = User.find_or_create_by(:email => email, :password => 'foobar', :password_confirmation => 'foobar')
	@specialist.update_attributes(:confirmed_at => Time.now)
	if @specialist.profile.nil?
		@specialist.profile = Profile.new(:name => name, :expertise => expertise)
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
  visit('/logout')
	visit new_user_registration_path
	register("random_new_user@test.com", "foobar")
end

def login(email, password)
    visit('/login')
    fill_in('user_email', :with => email)
    fill_in('user_password', :with => password)
    click_button('Inloggen')
end

def register(email, password)
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  fill_in "user_password_confirmation", :with => password
  click_button "Registreren"
end
