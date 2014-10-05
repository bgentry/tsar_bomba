require 'rails_helper'

RSpec.describe "fleets/show", :type => :view do
  before(:each) do
    @fleet = assign(:fleet, Fleet.create!(
      :instance_type => "t2.micro",
      :instance_count => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/t2.micro/)
    expect(rendered).to match(/1/)
  end
end
