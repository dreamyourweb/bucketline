require 'spec_helper'

describe Link do
	describe ".consolidate_links" do
		before(:each) do
			@project = Project.create(:query => "Mijn project", :start_at => Date.today, :end_at => Date.today, :daypart => ["Avond"])
			@item = @project.items.create(:name => "Mijn item", :start_at => Date.today, :end_at => Date.today, :daypart => ["Avond"], :type => "help", :amount => 2)
			@profile = Profile.create(:name => "Piet")
		end

		it "should add amounts of dublicate links together upon creation" do
			Link.all.entries.length.should == 0
			@item.link_to_profile(1, @profile)
			@profile.link_to_item(1, @item)
			Link.all.entries.length.should == 1
			@item.link_to_profile(1, @profile)
			@profile.link_to_item(1, @item)
			Link.all.entries.length.should == 1						
		end
	end
end
