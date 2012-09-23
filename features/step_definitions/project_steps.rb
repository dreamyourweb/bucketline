Given /^there is a project with an item$/ do
	step %{there is a project that belongs to an admin with an item}
end

Given /^there is a project that belongs to an admin with an item$/ do
	if @admin.nil?
		@admin = User.create(:email => 'admin@test.com', :password => 'foobar', :password_confirmation => 'foobar')
		@admin.profile = Profile.create #(:name => "Anoniempje")
		@admin.save
		@admin.update_attributes(:admin => true, :confirmed_at => Time.now)
		@admin.profile.update_attributes(:name => "Admin", :expertise => "Bier drinken")
	end
	@initiative = Initiative.last
	@project = @initiative.projects.create(:query => "Mijn project", :input_date => Date.tomorrow, :input_start_at => Time.now, :input_end_at => Time.now + 1.minute)
	@project.update_attributes(:owner_id => @admin.id)
	@item = @project.items.create(:name => "Mijn item", :type => "help", :amount => 1)
	#reload the page
  visit [ current_path, page.driver.request.env['QUERY_STRING'] ].reject(&:blank?).join('?')
end

When /^I follow the project link$/ do
  click_link @project.query
end

When /^the admin plans a project for tomorrow$/ do
	click_link('Bekijk initiatief')
	click_link('Kalender')
	click_link('Plaats nieuw project')
	fill_in("project_query", :with => "Mijn project")
	select(Date.tomorrow.day.to_s, :from => "project_input_date_3i")
	select(I18n.t("date.month_names")[Date.tomorrow.month], :from => "project_input_date_2i")
	select(Date.tomorrow.year.to_s, :from => "project_input_date_1i")
	select("10", :from => "project_input_start_at_4i")
	select("00", :from => "project_input_start_at_5i")
	select("12", :from => "project_input_end_at_4i")
	select("00", :from => "project_input_end_at_5i")
	click_button("Project en items opslaan")
end

When /^the admin cancels the project$/ do
	click_link "Bekijk initiatief"
	click_link "Mijn project"
 	click_link "Project verwijderen"
	#confirm javascript popup box	
end

When /^the admin edits the project$/ do
	visit "/projects"
	click_link "Mijn project"
	click_link "Project of items bewerken"
	fill_in("project_query", :with => "Mijn bewerkte project")
	click_button("Project en items opslaan")
end

Then /^I should see all the projects$/ do
  page.should have_content("Mijn project")
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
	select("10", :from => "project_input_start_at_4i")
	select("00", :from => "project_input_start_at_5i")
	select("12", :from => "project_input_end_at_4i")
	select("00", :from => "project_input_end_at_5i")
	select("Materiaal", :from => "project_items_attributes_0_type")
end

When /^I delete the project$/ do
	@project = Project.last
	@project.delete
end

Then /^I should see my project$/ do
  page.should have_content("Mijn project")
end

Given /^I have contributed to a project$/ do
	step %{I am logged in as a user}
	step %{there is a project that belongs to an admin with an item} 
	step %{no emails have been sent} 
	step %{I provide an item via the calendar page}
	#step %{I log out}
end
