#Declaring all the different roles

Given /^I am a visitor$/ do
  step %(I am not authenticated)
end

Given /^there is a user$/ do
  if !@user 
    @user = User.find_or_create_by(:email => 'initiative_user@test.com', :password => 'foobar', :password_confirmation => 'foobar', :name => "User")
    @user.update_attributes(:confirmed_at => Time.now)
  end
  @user.profile.update_attributes(:expertise => "Hard werken")
end

Given /^there is an admin$/ do
  if !@admin 
    @admin = User.create(:email => 'initiative_admin@test.com', :password => 'foobar', :password_confirmation => 'foobar', :name => "Admin")
    @admin.update_attributes(:confirmed_at => Time.now)
  end
  @admin.profile.update_attributes(:expertise => "Bier drinken")
end

Given /^there is a super admin$/ do
  if !@super_admin
    @super_admin = User.create(:email => 'super_admin@test.com', :password => 'foobar', :password_confirmation => 'foobar', :name => "Super Admin")
    @super_admin.update_attributes(:super_admin => true, :confirmed_at => Time.now)
  end
  @super_admin.profile.update_attributes(:expertise => "Bier brouwen")
end

When /^I fill in the form with my registration$/ do
  fill_in("user_name", :with => "New User")
  fill_in("user_email", :with => "new_user@test.com")
  fill_in("user_password", :with => "foobar")
  fill_in("user_password_confirmatio", :with => "foobar")
  click_button("Versturen")
end

#Coupling roles to initiatives

Given /^I am logged in as (?:|an )initiative user$/ do
  #Must be preceded by declaring an initiative in an earlier step
  step %{there is a user}
  @user.user_roles.create(:initiative_id => @initiative.id)
  login(@user.email, 'foobar')
end

Given /^there is an initiative user$/ do
  #Must be preceded by declaring an initiative in an earlier step
  step %{there is a user}
  @user.user_roles.create(:initiative_id => @initiative.id)
end

Given /^I am logged in as an initiative user for both initiatives$/ do
  #Must be preceded by declaring an initiative in an earlier step
  step %{there is a user}
  @user.user_roles.create(:initiative_id => @first_initiative.id)
  @user.user_roles.create(:initiative_id => @second_initiative.id)
  login(@user.email, 'foobar')
end

Given /^I am logged in as an initiative user for only one of the two initiatives$/ do
  #Must be preceded by declaring an initiative in an earlier step
  step %{there is a user}
  @user.user_roles.create(:initiative_id => @first_initiative.id)
  login(@user.email, 'foobar')
end


Given /^I am logged in as (?:|an )initiative admin$/ do
  #Must be preceded by declaring an initiative in an earlier step
  step %{there is an admin}
  @admin.user_roles.create(:initiative_id => @initiative.id, :admin => true)
  login(@admin.email, 'foobar')
end

Given /^I am logged in as (?:|a )super admin$/ do
  #Must be preceded by declaring an initiative in an earlier step
  step %{there is a super admin}
  login(@super_admin.email, 'foobar')
end

#Canonical steps

When /^the initiative admin logs in$/ do
  step %{I am logged in as an initiative admin}
end

When /^the (?:initiative admin|super admin|initiative user) logs out$/ do
	visit("/logout")
end

When /^the super admin logs in$/ do
  step %{I am logged in as a super admin}
end

Given /^(?:I am not authenticated|I log out)$/ do
  # Ensure at least:
  visit('/logout')
end

#Specific step for specialist

Given /^a specialist "([^"]*)" with email "([^"]*)" and expertise "([^"]*)" who provided his availability$/ do |name, email, expertise|
  #Must be preceded by declaring an initiative in an earlier step
  @specialist = User.create(:email => email, :password => 'foobar', :password_confirmation => 'foobar', :name => name)
  @specialist.user_roles.create(:initiative_id => @initiative.id)
	@specialist.update_attributes(:confirmed_at => Time.now)
	if @specialist.profile.nil?
		@specialist.profile = Profile.new(:expertise => expertise)
	end
	@profile = @specialist.profile
	@available_date = @profile.available_dates.create!(:date => Date.today, :daypart => ["Middag"])
	@available_date.save
end

#Registration and login steps

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
