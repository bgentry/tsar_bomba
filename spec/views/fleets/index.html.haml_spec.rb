require 'rails_helper'

RSpec.describe "fleets/index", :type => :view do
  before(:each) do
    assign(:fleets, [
      create(:fleet),
      create(:fleet),
    ])
  end

  it "renders a list of fleets" do
    render
    assert_select "tr>td", :text => "m3.large".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "us-east-1", :count => 2
  end
end
