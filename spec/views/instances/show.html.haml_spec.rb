require 'rails_helper'

RSpec.describe "instances/show", :type => :view do
  before(:each) do
    @fleet = assign(:fleet, Fleet.create!(
      :instance_count => 1,
      :instance_type => "m3.large",
    ))
    @instance = assign(:instance, Instance.create!(
      :fleet_id => @fleet.id,
      :provider_id => "Provider",
      :state => "State"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Provider/)
    expect(rendered).to match(/State/)
  end
end
