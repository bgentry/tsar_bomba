require 'rails_helper'

RSpec.describe "instances/show", :type => :view do
  before(:each) do
    @fleet = assign(:fleet, create(:fleet, instance_count: 1))
    @instance = assign(:instance, create(:instance, fleet: @fleet))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/#{@instance.provider_id}/)
    expect(rendered).to match(/#{@instance.state}/)
  end
end
