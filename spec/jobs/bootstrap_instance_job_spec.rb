require 'rails_helper'

RSpec.describe BootstrapInstanceJob, :type => :job do
  it { should respond_to :perform }

  it "should call :bootstrap! on the instance" do
    j = BootstrapInstanceJob.new
    instance = double("instance")
    expect(instance).to receive(:bootstrap!)
    j.perform(instance)
  end
end
