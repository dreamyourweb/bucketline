require 'spec_helper'

describe "user_roles/index" do
  before(:each) do
    assign(:user_roles, [
      stub_model(UserRole),
      stub_model(UserRole)
    ])
  end

  it "renders a list of user_roles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
