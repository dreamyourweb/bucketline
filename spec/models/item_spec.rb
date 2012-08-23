require 'spec_helper'

describe Item do
	before(:each) do
		@project = Project.create(:query => "Mijn project", :start_at => Date.today, :end_at => Date.today, :daypart => ["Avond"])
		@item = @project.items.create(:name => "Mijn item", :start_at => Date.today, :end_at => Date.today, :daypart => ["Avond"], :type => "help", :amount => 2)
		@user = User.create(:email => "test@dreamyourweb.nl", :password => "foobar", :password_confirmation => "foobar")
		@user.profile.update_attributes(:name => "Piet")
		@profile = @user.profile
	end

	describe ".provided" do
		it "should mark an item as provided if there is nothing left to give" do
			Link.create(:item_id => @item.id, :profile_id => @profile.id, :amount => 2)
			@item.provided.should == true			
		end

		it "should not mark an item as provided if there are items left to give" do
			Link.create(:item_id => @item.id, :profile_id => @profile.id, :amount => 1)
			@item.provided.should == false			
		end
	end

	describe ".items_left" do
		it "should show the up-to-date amount of required items" do
			@item.items_left.should == 2
			@item.links.create(:profile_id => @profile.id, :amount => 1)
			@item.items_left.should == 1		
		end
	end
end
