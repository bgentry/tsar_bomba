require 'rails_helper'

RSpec.describe WaitForInstanceRunningJob, :type => :job do
  it { should respond_to :perform }

  context "if the remote is ready" do
    it "should transition to running" do
      instance = double("instance", remote: double("remote", :ready? => true))
      expect(instance).to receive(:running!)
      WaitForInstanceRunningJob.new.perform(instance)
    end
  end

  context "if the remote is not ready" do
    let(:instance) { spy("instance") }
    let(:remote) { double("remote instance", :ready? => false, :state => "pending") }

    before { expect(instance).to receive(:remote) { remote } }

    it "should not transition to running" do
      WaitForInstanceRunningJob.new.perform(instance)
      expect(instance).to_not have_received(:running!)
    end

    it "should retry the job in 10 seconds" do
      j = WaitForInstanceRunningJob.new
      expect(j).to receive(:retry_job).with(wait: 10.seconds)
      j.perform(instance)
    end
  end

  context "if the state is terminated" do
    it "should transition to running" do
      j = WaitForInstanceRunningJob.new
      instance = double("instance", remote: double("remote", :ready? => false, :state => "terminated"))
      expect(instance).to_not receive(:running!)
      expect(j).to_not receive(:retry_job)
      j.perform(instance)
    end
  end

  context "if the remote is nil" do
    it "should retry the job in 10 seconds" do
      j = WaitForInstanceRunningJob.new
      instance = double("instance", remote: nil)
      expect(j).to receive(:retry_job).with(wait: 10.seconds)
      j.perform(instance)
    end
  end
end
