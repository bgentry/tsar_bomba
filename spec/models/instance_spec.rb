require 'rails_helper'

RSpec.describe Instance, :type => :model do
  let(:fleet)    { create(:fleet) }
  let(:instance) { create(:instance, fleet: fleet) }

  it { should belong_to(:fleet) }

  context 'workflow' do
    it { should respond_to(:awaiting_launch?) }
    it { should respond_to(:launch!) }

    it { should respond_to(:launched?) }
    it { should respond_to(:running!) }

    it { should respond_to(:running?) }
    it { should respond_to(:bootstrap!) }

    it { should respond_to(:ready?) }

    it "should begin with state awaiting_launch" do
      expect(build_stubbed(:instance).awaiting_launch?).to eq(true)
    end

    it "should transition from awaiting_launch to launched" do
      instance.launch!
      expect(instance.launched?).to eq(true)
    end

    it "should transition from launched to running" do
      instance.update_attribute(:state, "launched")
      instance.running!
      expect(instance.running?).to eq(true)
    end

    it "should transition from running to ready" do
      instance.update_attribute(:state, "running")
      instance.bootstrap!
      expect(instance.ready?).to eq(true)
    end
  end
end
