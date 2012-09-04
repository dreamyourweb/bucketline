Given /^there is a loose item$/ do
	Item.create(:name => "Mijn los item", :type => "help", :amount => 1)
end

When /^I fill the form with a loose item$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see my new loose item$/ do
	page.should have_content("Mijn los item")
end
