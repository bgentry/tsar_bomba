require 'rails_helper'

RSpec.describe "runs/index", :type => :view do
  let(:fleet) { create(:fleet) }
  let(:run1) do
    create(:run,
      :fleet => fleet,
      :target => "Target",
      :host_header => "Host Header",
      :duration => 600,
      :rate => 200,
    )
  end
  let(:run2) do
    create(:run,
      :fleet => fleet,
      :target => "Target",
      :host_header => "Host Header",
      :duration => 60,
      :rate => 100,
    )
  end

  before(:each) do
    assign(:runs, [run1, run2])
  end

  it "renders a list of runs" do
    render
    assert_select "tr>td", :text => fleet.id.to_s, :count => 3
    assert_select "tr>td", :text => "Target".to_s, :count => 2
    assert_select "tr>td", :text => "Host Header".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 1
    assert_select "tr>td", :text => 100.to_s, :count => 1
    assert_select "tr>td", :text => 200.to_s, :count => 1
    assert_select "tr>td", :text => 60.to_s, :count => 1
    assert_select "tr>td", :text => 600.to_s, :count => 1
    assert_select "tr>td", :text => "initiated".to_s, :count => 2
  end
end
