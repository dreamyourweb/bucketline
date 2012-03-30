require 'spec_helper'

describe Item do
	describe ".provided" do
		before(:each) do
			@project = Project.create(:query => "Mijn project", :start_at => Time.now, :end_at => Time.now + 1.day)
			@item = @project.items.create(:name => "Mijn item", :type => "help", :notes => "", :location => "HvO", :amount => 1, :start_at => Time.now, :end_at => Time.now + 1.day)
 		end

  	it "should return true if there are no items left to give" do
		end

		it "should return false if there are items left to give" do
		end
	end
end
