require 'spec_helper'

describe User do
  describe ".check_or_create_profile" do
		before(:each) do
			@user = User.create(:email => "user_profile@test.com", :password => "foobar", :password_confirmation => "foobar")
		end
		
		it "should create a profile on user create" do
			@user.profile.should_not be_nil
		end

		it "should not create a profile if a profile is already present" do
			@user.profile.update_attributes(:name => "Piet")
			@user.update_attributes(:admin => true)
			@user.profile.name.should == "Piet"	
		end
	end
end
