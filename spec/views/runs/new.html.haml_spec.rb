require 'rails_helper'

RSpec.describe "runs/new", :type => :view do
  before(:each) do
    assign(:run, Run.new(
      :fleet_id => 1,
      :target => "MyString",
      :host_header => "MyString",
      :duration => 1,
      :rate => 1,
      :state => "MyString",
      :notes => "This is an important run",
    ))
  end

  it "renders new run form" do
    render

    assert_select "form[action=?][method=?]", runs_path, "post" do

      assert_select "input#run_fleet_id[name=?]", "run[fleet_id]"

      assert_select "input#run_target[name=?]", "run[target]"

      assert_select "input#run_host_header[name=?]", "run[host_header]"

      assert_select "input#run_duration[name=?]", "run[duration]"

      assert_select "input#run_rate[name=?]", "run[rate]"

      assert_select "textarea#run_notes[name=?]", "run[notes]"
    end
  end
end
