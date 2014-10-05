require 'rails_helper'

RSpec.describe "fleets/edit", :type => :view do
  before(:each) do
    @fleet = assign(:fleet, Fleet.create!(
      :instance_type => "t2.micro",
      :instance_count => 1
    ))
  end

  it "renders the edit fleet form" do
    render

    assert_select "form[action=?][method=?]", fleet_path(@fleet), "post" do

      assert_select "select#fleet_instance_type[name=?]", "fleet[instance_type]"

      assert_select "input#fleet_instance_count[name=?]", "fleet[instance_count]"
    end
  end
end
