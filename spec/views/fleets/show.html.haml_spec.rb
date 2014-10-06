require 'rails_helper'

RSpec.describe "fleets/show", :type => :view do
  before(:each) do
    @fleet = assign(:fleet, Fleet.create!(
      :instance_type => "t2.micro",
      :instance_count => 1
    ))
    @instance1 = @fleet.instances.create!(provider_id: "i-abcd1234")
    @instance2 = @fleet.instances.create!(provider_id: "i-deadbeef")
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/t2.micro/)
    expect(rendered).to match(/1/)
  end

  it "renders a list of instances in the fleet" do
    render
    assert_select "tr>td", :text => "i-abcd1234", :count => 1
    assert_select "tr>td", :text => "i-deadbeef", :count => 1
  end
end
