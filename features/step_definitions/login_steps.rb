Given /^I am logged in as (?:|a )super admin$/ do
  #Must be preceded by declaring an initiative in an earlier step
  @super_admin = User.find_or_create_by(:email => 'super_admin@test.com', :password => 'foobar', :password_confirmation => 'foobar', :name => "Super Admin")
  @super_admin.update_attributes(:super_admin => true, :confirmed_at => Time.now)
  @admin.profile.update_attributes(:expertise => "Bier brouwen")
  login(@super_admin.email, 'foobar')
end

Given /^I am logged in as (?:|an )initiative user$/ do
  #Must be preceded by declaring an initiative in an earlier step
  @user = User.find_or_create_by(:email => 'initiative_user@test.com', :password => 'foobar', :password_confirmation => 'foobar', :name => "User")
  @user.update_attributes(:confirmed_at => Time.now)
  @admin.user_role.create(:initiative_id => @initiative.id)
  @user.profile.update_attributes(:expertise => "Hard werken")
  login(@user.email, 'foobar')
end

Given /^I am logged in as (?:|an )initiative admin$/ do
  #Must be preceded by declaring an initiative in an earlier step
  @admin = User.find_or_create_by(:email => 'initiative_admin@test.com', :password => 'foobar', :password_confirmation => 'foobar', :name => "Admin")
  @admin.user_role.create(:initiative_id => @initiative.id, :admin => true)
	@admin.profile.update_attributes(:expertise => "Bier drinken")
  login(@admin.email, 'foobar')
end

When /^the super admin logs in$/ do
  step %{I am logged in as a super admin}
end

When /^the initiative admin logs in$/ do
  step %{I am logged in as an initiative admin}
end

When /^the (initiative admin|super admin|initiative user) logs out$/ do
	visit("/logout")
end

Given /^I am a visitor$/ do
  step %(I am not authenticated)
end

#Given /^a super admin with email "([^"]*)"$/ do |arg1|
#  @admin = User.find_or_create_by(:email => arg1, :password => 'foobar', :password_confirmation => 'foobar', :name => "Admin")
#	@admin.update_attributes(:super_admin => true, :confirmed_at => Time.now)
#end

Given /^a specialist "([^"]*)" with email "([^"]*)" and expertise "([^"]*)" who provided his availability$/ do |name, email, expertise|
  #Must be preceded by declaring an initiative in an earlier step
  @specialist = User.find_or_create_by(:email => email, :password => 'foobar', :password_confirmation => 'foobar', :name => name)
  @specialist.user_role.create(:initiative_id => @initiative.id)
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

When /^the super admin logs in via the login screen$/ do
	login("super_admin@test.com", "foobar")
end

When /^the initiative admin logs in via the login screen$/ do
  login("initiative_admin@test.com", "foobar")
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
