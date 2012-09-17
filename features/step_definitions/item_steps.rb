Given /^there is a loose item$/ do
	Item.create(:name => "Mijn los item", :type => "help", :amount => 1)
end

When /^I fill the form with a loose item$/ do
  fill_in('item_name', :with => "Mijn los item")
  fill_in('item_description', :with => "Een korte toelichting")
  click_button('Item plaatsen')	
end

Then /^I should see my new loose item$/ do
	page.should have_content("Mijn los item")
	page.should have_content("Een korte toelichting")
end

When /^I provide an item via the calendar page$/ do
	step %{I go to the calendar page}
	step %{I click on a project}
	step %{I provide 1 item}
end

When /^I retreat my contribution$/ do
	click_link "ntrekken" #/[B|b]ijdrage [I|i]ntrekken/i
end
