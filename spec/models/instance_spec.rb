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

  it { should respond_to(:launch) }

  context :launch do
    it "should launch an EC2 instance" do
      proxy = instance.send(:fog_client).servers
      allow(instance.send(:fog_client)).to receive(:servers).and_return(proxy)
      expect(proxy).to receive(:create_many).with(1, 1, {
        flavor_id: fleet.instance_type,
        image_id: Providers::AWS.images[fleet.provider_region],
      }).and_call_original
      instance.launch
    end

    it "should set the provider_id" do
      instance.update_attribute(:provider_id, nil)
      instance.launch
      expect(instance.provider_id).to match(/\Ai-[a-f0-9]{8}\z/)
    end
  end

  it { should respond_to(:destroy_instance) }

  context :destroy_instance do
    before do
      instance.launch
    end

    it "should call terminate_instances with the provider_id" do
      expect(instance.send(:fog_client)).to receive(:terminate_instances).
        with(instance.provider_id).and_call_original
      instance.destroy_instance
    end
  end

  context :enqueue_launch do
    let(:instance) { build(:instance) }

    it "should receive :enqueue_launch after create" do
      expect(instance).to receive(:enqueue_launch)
      instance.save!
    end

    it "should enqueue a LaunchInstanceJob" do
      expect(LaunchInstanceJob).to receive(:perform_later).with(instance)
      instance.send(:enqueue_launch)
    end
  end

  context :fog_client do
    it "should return a Fog AWS client" do
      expect(Instance.new.send(:fog_client)).to be_a(Fog::Compute::AWS::Mock)
    end
  end
end
