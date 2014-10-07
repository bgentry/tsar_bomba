require 'rails_helper'

RSpec.describe CreateInstancesJob, :type => :job do
  it { should respond_to :perform }

  it "should create instance_count instances" do
    fleet = build(:fleet, instance_count: 3)
    allow(fleet).to receive(:enqueue_create_instances)
    fleet.save!

    CreateInstancesJob.new.perform(fleet)
    expect(fleet.instances.count).to eq(3)
  end
end
