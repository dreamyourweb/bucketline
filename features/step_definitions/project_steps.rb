Given /^there is a project with an item$/ do
	@project = Project.create(:query => "Mijn project", :start_at => Time.now, :end_at => Time.now + 1.day)
	@item = @project.items.create(:name => "Mijn item", :type => "help", :notes => "", :location => "HvO", :amount => 1, :start_at => Time.now, :end_at => Time.now + 1.day)
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
  fill_in("project_items_attributes_0_location", :with => "HvO")
end

Then /^I should see my project$/ do
  page.should have_content("Mijn project")
end
