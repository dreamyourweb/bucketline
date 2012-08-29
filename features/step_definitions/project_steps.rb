Given /^there is a project with an item$/ do
	@project = Project.create(:query => "Mijn project", :start_at => Date.today, :end_at => Date.tomorrow, :daypart => ["Middag", "Avond"])
	@item = @project.items.create(:name => "Mijn item", :type => "help", :amount => 1, :start_at => Date.today, :end_at => Date.tomorrow, :daypart => ["Middag", "Avond"])
end

Given /^there is a project that belongs to an admin with an item$/ do
  @admin = User.find_or_create_by(:email => 'admin@test.com', :password => 'foobar', :password_confirmation => 'foobar')
	@admin.update_attributes(:admin => true, :confirmed_at => Time.now)
	@admin.profile.update_attributes(:name => "Admin", :expertise => "Bier drinken")
	@project = @admin.owned_projects.create(:query => "Mijn project", :start_date => Date.today, :start_time => Time.now, :end_time => Time.now + 1.hour)
	@item = @project.items.create(:name => "Mijn item", :type => "help", :amount => 1)
end

When /^I follow the project link$/ do
  click_link @project.query
end

When /^the admin plans a project for tomorrow$/ do
	click_link('Project kalender')
	click_link('Plaats nieuw project')
	fill_in("project_query", :with => "Mijn project")
	select(Date.tomorrow.day.to_s, :from => "project_date_3i")
	select(I18n.t("date.month_names")[Date.tomorrow.month], :from => "project_date_2i")
	select(Date.tomorrow.year.to_s, :from => "project_date_1i")
	select("10", :from => "start_time_4i")
	select("00", :from => "start_time_5i")
	select("12", :from => "end_time_4i")
	select("00", :from => "end_time_5i")
	click_button("Project en items opslaan")
end

When /^the admin cancels the project$/ do
	visit "/projects"
  click_link "Mijn project"
  click_link "Project verwijderen"
	#confirm javascript popup box	
end

Then /^I should see all the projects$/ do
  page.should have_content("Mijn project")
end

Then /^I should see all the items$/ do
  page.should have_content("Mijn item")
end

When /^I click on an item$/ do
  click_link "Mijn item"
end

When /^I provide (\d+) item$/ do |arg1|
	click_button("Dit wil ik bijdragen!")
end

When /^I click on a project$/ do
  click_link "Mijn project"
end

When /^I fill in the form with a project and an item$/ do
  fill_in("project_query", :with => "Mijn project")
  fill_in("project_items_attributes_0_name", :with => "Mijn item")
	select("Materiaal", :from => "project_items_attributes_0_type")
end

When /^I delete the project$/ do
	@project = Project.last
	@project.delete
end

Then /^I should see my project$/ do
  page.should have_content("Mijn project")
end
