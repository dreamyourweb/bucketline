require 'spec_helper'

describe Profile do
	before(:each) do
		@project = Project.create(:query => "Mijn project", :start_at => Date.today, :end_at => Date.today, :daypart => ["Avond"])
		@item = @project.items.create(:name => "Mijn item", :start_at => Date.today, :end_at => Date.today, :daypart => ["Avond"], :type => "help", :amount => 2)
		@user = User.create(:email => "test@dreamyourweb.nl", :password => "foobar", :password_confirmation => "foobar")
		@user.profile.update_attributes(:name => "Piet")
		@profile = @user.profile
	end

	describe ".link_to_item" do
		it "should link a profile to an item if the user provides an item" do
			@profile.link_to_item(1, @item)
			@profile.items.first.should == @item
		end

		it "should create a link instance to keep track of the amount of items that the profile has provided" do
			Link.where(:item_id => @item.id, :profile_id => @profile.id).length.should == 0
			@profile.link_to_item(1, @item)
			Link.where(:item_id => @item.id, :profile_id => @profile.id).length.should == 1
		end
	end

	describe ".remove_links" do
		it "should remove the links to items upon deletion of the profile" do
			Link.where(:item_id => @item.id, :profile_id => @profile.id).length.should == 0
			@item.link_to_profile(1, @profile)
			@profile.link_to_item(1, @item)
			Link.where(:item_id => @item.id, :profile_id => @profile.id).length.should == 1
			@profile.destroy
			Link.where(:item_id => @item.id, :profile_id => @profile.id).length.should == 0
		end
	end

	describe ".remove_item" do
		it "should remove the item from the user profile if the user retreats his contribution" do
			@profile.link_to_item(1, @item)
			@profile.items.first.should == @item
			@profile.remove_item(@item)
			@profile.items.first.should == nil
		end

		it "should remove the link instance if the user retreats his contribution" do
			Link.where(:item_id => @item.id, :profile_id => @profile.id).length.should == 0
			@profile.link_to_item(1, @item)
			Link.where(:item_id => @item.id, :profile_id => @profile.id).length.should == 1
			@profile.remove_item(@item)
			Link.where(:item_id => @item.id, :profile_id => @profile.id).length.should == 0
		end
	end
end
