require 'rails_helper'

RSpec.describe "fleets/show", :type => :view do
  before(:each) do
    @fleet = assign(:fleet, create(:fleet, instance_count: 2))
    @instance1 = create(:instance, fleet: @fleet)
    @instance2 = create(:instance, fleet: @fleet)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{@fleet.provider_region}/)
    expect(rendered).to match(/#{@fleet.instance_type}/)
    expect(rendered).to match(/#{@fleet.instance_count}/)
  end

  it "renders a list of instances in the fleet" do
    render
    assert_select "tr>td", :text => @instance1.provider_id, :count => 1
    assert_select "tr>td", :text => @instance2.provider_id, :count => 1
  end
end
