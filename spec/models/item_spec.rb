require 'spec_helper'

describe Item do
	describe ".provided" do
		before(:each) do
			@project = Project.create(:query => "Mijn project", :start_at => Time.now, :end_at => Time.now + 1.day)
			@item = @project.items.create(:name => "Mijn item", :type => "help", :notes => "", :location => "HvO", :amount => 1, :start_at => Time.now, :end_at => Time.now + 1.day)
 		end

  	it "should return true if there are no items left to give" do
			@item.update_attributes(:amount => 0)
			@item.provided.should be true
		end

		it "should return false if there are items left to give" do
			@item.provided.should be false
		end
	end

	describe ".decrease_amount" do
		before(:each) do
			@project = Project.create(:query => "Mijn project", :start_at => Time.now, :end_at => Time.now + 1.day)
			@item = @project.items.create(:name => "Mijn item", :type => "help", :notes => "", :location => "HvO", :amount => 1, :start_at => Time.now, :end_at => Time.now + 1.day)
 		end

		it "should decrease the amount when an item is provided" do
			@item.decrease_amount(1)
			@item.amount.should be 0
		end
		
		it "should set the amount to 0 if the amount is negative" do
			@item.decrease_amount(2)
			@item.amount.should be 0
		end

		it "should save the user name of the last providing user" do
			@item.decrease_amount(1, "Hans")
			@item.provided_by_last_user_name.should == "Hans"
		end
	end
end
