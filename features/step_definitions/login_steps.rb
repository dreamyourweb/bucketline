Given /^I am logged in as an admin$/ do
  @admin = User.find_or_create_by(:email => 'admin@test.com', :password => 'foobar', :password_confirmation => 'foobar')
	@admin.update_attributes(:admin => true, :name => "Admin")
  login(@admin.email, @admin.password)
end

Given /^I am a visitor$/ do
  step %(I am not authenticated)
end

Given /^I am logged in as a user$/ do
  @user = User.find_or_create_by(:email => 'user@test.com', :password => 'foobar', :password_confirmation => 'foobar')
	@user.update_attributes(:name => "User")
  login(@user.email, @user.password)
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
  fill_in "Wachtwoord bevestigen", :with => "please"
  click_button "Registreer"
end
