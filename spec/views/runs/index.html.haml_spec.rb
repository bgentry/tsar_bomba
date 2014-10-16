require 'rails_helper'

RSpec.describe "runs/index", :type => :view do
  let(:fleet) { create(:fleet) }

  before(:each) do
    assign(:runs, [
      create(:run,
        :fleet => fleet,
        :target => "Target",
        :host_header => "Host Header",
        :duration => 2,
        :rate => 3,
      ),
      create(:run,
        :fleet => fleet,
        :target => "Target",
        :host_header => "Host Header",
        :duration => 2,
        :rate => 3,
      )
    ])
  end

  it "renders a list of runs" do
    render
    assert_select "tr>td", :text => fleet.id.to_s, :count => 2
    assert_select "tr>td", :text => "Target".to_s, :count => 2
    assert_select "tr>td", :text => "Host Header".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "initiated".to_s, :count => 2
  end
end