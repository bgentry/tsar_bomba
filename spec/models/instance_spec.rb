require 'rails_helper'

RSpec.describe Instance, :type => :model do
  let(:fleet)    { create(:fleet) }
  let(:instance) { create(:instance, fleet: fleet) }

  it { should belong_to(:fleet) }

  before do
    Providers::AWS.create_key_pair
  end

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
      allow(instance).to receive(:remote).and_return(double("remote", dns_name: "abcd.internal"))
      instance.state = "launched"
      instance.running!
      expect(instance.running?).to eq(true)
    end

    it "should transition from running to ready" do
      instance.update_attribute(:state, "running")
      allow(instance).to receive(:bootstrap)
      instance.bootstrap!
      expect(instance.ready?).to eq(true)
    end
  end

  it { should respond_to(:launch) }

  context :launch do
    it "should launch an EC2 instance" do
      # TODO: unless instance is called first, :create_many gets called twice
      # due to background jobs being processed.
      instance # TODO create it, fix so this isn't needed
      proxy = Providers::AWS.fog_client.servers
      allow(Providers::AWS.fog_client).to receive(:servers).and_return(proxy)
      expect(proxy).to receive(:create_many).with(1, 1, {
        flavor_id: fleet.instance_type,
        image_id: Providers::AWS.images[fleet.provider_region],
        key_name: Providers::AWS::KEY_PAIR_NAME,
        security_group_ids: Providers::AWS::SECURITY_GROUP_NAME,
      }).and_call_original
      instance.launch
    end

    it "should set the provider_id" do
      instance.update_attribute(:provider_id, nil)
      instance.launch
      expect(instance.provider_id).to match(/\Ai-[a-f0-9]{8}\z/)
    end

    it "should enqueue a WaitForInstanceRunningJob" do
      expect(WaitForInstanceRunningJob).to receive(:perform_later).with(instance)
      instance.launch
    end
  end

  it { should respond_to(:running) }

  describe :running do
    before do
      allow(instance).to receive(:remote).and_return(double("remote", dns_name: "abcd.internal"))
    end

    it "should set the dns_name" do
      instance.update_attribute(:dns_name, nil)
      instance.running
      expect(instance.dns_name).to eq("abcd.internal")
    end

    it "should enqueue a BootstrapInstanceJob" do
      proxy = BootstrapInstanceJob.set(20.seconds)
      expect(BootstrapInstanceJob).to receive(:set).with(wait: 20.seconds).and_return(proxy)
      expect(proxy).to receive(:perform_later).with(instance)
      instance.running
    end
  end

  it { should respond_to(:destroy_instance) }

  context :destroy_instance do
    before do
      instance.launch
    end

    it "should call terminate_instances with the provider_id" do
      expect(Providers::AWS.fog_client).to receive(:terminate_instances).
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
end
