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
	if @user.profile.nil?
		@user.profile = Profile.new(:name => "User", :expertise => "Hard werken")
		@user.save
	end
  login(@user.email, 'foobar')
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
