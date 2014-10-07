require 'rails_helper'

RSpec.describe LaunchInstanceJob, :type => :job do
  it { should respond_to :perform }

  it "should create instance_count instances" do
    instance = create(:instance)
    expect(instance).to receive(:launch!)
    LaunchInstanceJob.new.perform(instance)
  end
end
