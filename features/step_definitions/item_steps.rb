Given /^there is a loose item$/ do
	Initiative.first.items.create(:name => "Mijn los item", :type => "help", :amount => 1)
end

Given /^I have contributed to a loose item$/ do
  step %{I am logged in as an admin}
  click_link "Ons verlanglijstje"
  click_link "Plaats nieuw item op verlanglijstje"
  step %{I fill the form with a loose item}
  step %{I log out}
  step %{I am logged in as a user}  
  click_link "Ons verlanglijstje"
  click_button "Dit wil ik bijdragen!"
end

When /^the admin cancels the item$/ do
  click_link "Ons verlanglijstje"
  click_link "Item verwijderen"
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

When /^the admin places a loose item$/ do
	click_link('Ons verlanglijstje')
	click_link('Plaats nieuw item op verlanglijstje')
	step %(I fill the form with a loose item)
end

When /^I retreat my contribution$/ do
	click_link "intrekken" #/[B|b]ijdrage intrekken/i
end
