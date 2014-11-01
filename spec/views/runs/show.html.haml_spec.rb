require 'rails_helper'

RSpec.describe "runs/show", :type => :view do
  before(:each) do
    @run = assign(:run, create(:run,
      :target => "Target",
      :host_header => "Host Header",
      :duration => 2,
      :rate => 3,
      :state => "State"
    ))
    @estimator = assign(:estimator, Quantile::Estimator.new)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{@run.id}/)
    expect(rendered).to match(/#{@run.fleet.id}/)
    expect(rendered).to match(/Target/)
    expect(rendered).to match(/Host Header/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/State/)
  end
end
