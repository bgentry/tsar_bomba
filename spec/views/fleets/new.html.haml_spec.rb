require 'rails_helper'

RSpec.describe "fleets/new", :type => :view do
  before(:each) do
    assign(:fleet, Fleet.new(
      :instance_type => "MyString",
      :instance_count => 1
    ))
  end

  it "renders new fleet form" do
    render

    assert_select "form[action=?][method=?]", fleets_path, "post" do

      assert_select "select#fleet_instance_type[name=?]", "fleet[instance_type]"

      assert_select "input#fleet_instance_count[name=?]", "fleet[instance_count]"
    end
  end
end
