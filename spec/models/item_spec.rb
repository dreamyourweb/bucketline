require 'spec_helper'

describe Item do
	before(:each) do
		@project = Project.create(:query => "Mijn project", :start_at => Date.today, :end_at => Date.today, :daypart => ["Avond"])
		@item = @project.items.create(:name => "Mijn item", :start_at => Date.today, :end_at => Date.today, :daypart => ["Avond"], :type => "help", :amount => 2)
		@profile = Profile.create(:name => "Piet")
	end

	describe ".provided" do
		it "should mark an item as provided if there is nothing left to give" do
			@item.link_to_profile(2, @profile)
			@profile.link_to_item(2, @item)
			@item.provided.should == true			
		end

		it "should not mark an item as provided if there are items left to give" do
			@item.link_to_profile(1, @profile)
			@profile.link_to_item(1, @item)
			@item.provided.should == false			
		end
	end

	describe ".link_to_profile" do
		it "should link an item to a profile if the item is being provided" do
			@item.link_to_profile(1, @profile)
			@item.profiles.first.should == @profile
		end
	end

	describe ".remove_profile" do
		it "should remove an item from a profile if the item is being removed" do
			@item.link_to_profile(1, @profile)
			@item.profiles.first.should == @profile
			@item.remove_profile(@profile)
			@item.profiles.first.should == nil
		end
	end

	describe ".items_left" do
		it "should show the up-to-date amount of required items" do
			@item.items_left.should == 2
			@item.link_to_profile(1, @profile)
			@profile.link_to_item(1, @item)
			@item.items_left.should == 1		
		end
	end
end
