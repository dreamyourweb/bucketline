Given /^I am logged in as an admin$/ do
  @admin = User.find_or_create_by(:email => 'admin@test.com', :password => 'foobar', :password_confirmation => 'foobar')
	if @admin.profile.nil?
		@admin.profile = Profile.new(:name => "Admin", :expertise => "Bier drinken")
		@admin.save
	end
	@admin.update_attributes(:admin => true)
  login(@admin.email, 'foobar')
end

Given /^I am a visitor$/ do
  step %(I am not authenticated)
end

Given /^I am logged in as a user$/ do
  @user = User.find_or_create_by(:email => 'user@test.com', :password => 'foobar', :password_confirmation => 'foobar')
	@user.profile.update_attributes(:name => "User", :expertise => "Hard werken")
  login(@user.email, 'foobar')
end

When /^show me the user$/ do
  p @user.profile
end

Given /^a specialist "([^"]*)" with email "([^"]*)" and expertise "([^"]*)" who provided his availability$/ do |name, email, expertise|
  @specialist = User.find_or_create_by(:email => email, :password => 'foobar', :password_confirmation => 'foobar')
	if @specialist.profile.nil?
		@specialist.profile = Profile.new(:name => name, :expertise => expertise)
		@profile = @specialist.profile
		@profile.available_dates.create!(:start_at => Time.now, :end_at => Time.now + 1.day)
		@specialist.save
	end
end

Given /^(?:I am not authenticated|I log out)$/ do
 	# Ensure at least:
  visit('/logout')
end

def login(email, password)
    visit('/login')
    fill_in('Email', :with => email)
    fill_in('Password', :with => password)
    click_button('Sign in')
end

def login_admin(email, password)
		visit('/admin/login')
    fill_in('Email', :with => email)
    fill_in('Wachtwoord', :with => password)
    click_button('Sign in')
end	

def register(email, password)
  fill_in "Email", :with => email
  fill_in "Wachtwoord", :with => password
  fill_in "Wachtwoord bevestigen", :with => password
  click_button "Registreer"
end
