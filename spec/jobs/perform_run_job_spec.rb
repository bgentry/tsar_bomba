require 'rails_helper'

RSpec.describe PerformRunJob, :type => :job do
  let(:run) { create(:run) }

  before do
    allow(run).to receive(:perform)
  end

  it { should respond_to :perform }

  it "should call start! on the run" do
    allow(run).to receive(:perform)

    expect(run).to receive(:start!).and_call_original
    PerformRunJob.new.perform(run)
  end

  it "should call finish! on the run" do
    expect(run).to receive(:finish!).and_call_original
    PerformRunJob.new.perform(run)
  end
end
