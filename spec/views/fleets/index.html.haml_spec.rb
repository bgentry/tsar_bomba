require 'rails_helper'

RSpec.describe "fleets/index", :type => :view do
  before(:each) do
    assign(:fleets, [
      Fleet.create!(
        :instance_type => "t2.micro",
        :instance_count => 1
      ),
      Fleet.create!(
        :instance_type => "t2.micro",
        :instance_count => 1
      )
    ])
  end

  it "renders a list of fleets" do
    render
    assert_select "tr>td", :text => "t2.micro".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
