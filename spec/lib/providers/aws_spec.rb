require 'spec_helper'
require 'providers/aws'

RSpec.describe Providers::AWS do
  it "should have FLAVORS set to the correct array" do
    expect(Providers::AWS.constants).to include(:FLAVORS)
    expect(Providers::AWS::FLAVORS).to be_a(Array)
    expect(Providers::AWS::FLAVORS).to include("m3.large")
    expected_flavors = Fog::Compute[:aws].flavors.select do |f|
      f.bits == 64 && f.instance_store_volumes > 0
    end.map(&:id)
    expect(Providers::AWS::FLAVORS).to eq(expected_flavors)
  end

  it "should have NON_HVM_FLAVORS set to the correct array" do
    expect(Providers::AWS.constants).to include(:NON_HVM_FLAVORS)
    expect(Providers::AWS::NON_HVM_FLAVORS).to be_a(Array)
    expect(Providers::AWS::NON_HVM_FLAVORS).to eq(%w{
      t1.micro m1.small m1.medium m1.large m1.xlarge c1.medium c1.xlarge
      m2.xlarge m2.2xlarge m2.4xlarge
    })
  end

  it "should have HVM_FLAVORS set to the correct array" do
    expect(Providers::AWS.constants).to include(:HVM_FLAVORS)
    expect(Providers::AWS::HVM_FLAVORS).to be_a(Array)
    expect(Providers::AWS::HVM_FLAVORS).to eq(Providers::AWS::FLAVORS - Providers::AWS::NON_HVM_FLAVORS)
  end

  it "should have REGIONS set to the correct array" do
    expect(Providers::AWS.constants).to include(:REGIONS)
    expect(Providers::AWS::REGIONS).to be_a(Array)
    expect(Providers::AWS::REGIONS).to eq(%w{
      us-east-1 us-west-1 us-west-2 eu-west-1 ap-southeast-1
      ap-southeast-2 ap-northeast-1 sa-east-1
    })
  end

  it "should have INSTANCE_STORE_AMIS set to a hash" do
    expect(Providers::AWS.constants).to include(:INSTANCE_STORE_AMIS)
    expect(Providers::AWS::INSTANCE_STORE_AMIS).to be_a(Hash)
    expect(Providers::AWS::INSTANCE_STORE_AMIS.length).to be > 0
  end

  it { should respond_to(:flavors) }

  describe :flavors do
    it "should return FLAVORS" do
      expect(Providers::AWS.flavors).to eq(Providers::AWS::HVM_FLAVORS)
    end
  end

  it { should respond_to(:images) }

  describe :images do
    it "should return INSTANCE_STORE_AMIS" do
      expect(Providers::AWS.images).to eq(Providers::AWS::INSTANCE_STORE_AMIS)
    end
  end

  it { should respond_to(:regions) }

  describe :regions do
    it "should return REGIONS" do
      expect(Providers::AWS.regions).to eq(Providers::AWS::REGIONS)
    end
  end

  context :fog_client do
    it "should return a Fog AWS client" do
      expect(Providers::AWS.fog_client).to be_a(Fog::Compute::AWS::Mock)
    end
  end

  it { should respond_to(:bootstrap!) }

  describe :bootstrap! do
    describe "security group" do
      it "should create the security group if it doesn't exist" do
        Providers::AWS.bootstrap!
        expect(Providers::AWS.fog_client.security_groups.all("group-name" => "tsar_bomba")).to be_present
      end

      it "should not try to create the security group it exists" do
        Providers::AWS.create_security_group
        expect(Providers::AWS).to_not receive(:create_security_group)
        Providers::AWS.bootstrap!
      end
    end

    describe "security group rules" do
      it "should call authorize_security_group if the security rule doesn't exist" do
        Providers::AWS.create_security_group
        expect(Providers::AWS).to receive(:authorize_security_group)
        Providers::AWS.bootstrap!
      end
    end

  end

  describe :authorize_security_group do
    before do
      Providers::AWS.create_security_group
    end

    it "should authorize the security group for inbound TCP port 22 access" do
      group = proc do
        Providers::AWS.fog_client.security_groups.all("group-name" => Providers::AWS::SECURITY_GROUP_NAME).first
      end
      expect(group.call.ip_permissions).to eq([])
      Providers::AWS.authorize_security_group
      expect(group.call.ip_permissions).to include({
        "ipProtocol"=>"tcp",
        "fromPort"=>22,
        "toPort"=>22,
        "groups"=>[],
        "ipRanges"=>[{"cidrIp"=>"0.0.0.0/0"}],
      })
    end

    it "should rescue the error if the rule already exists" do
      Providers::AWS.authorize_security_group
      expect { Providers::AWS.authorize_security_group }.to_not raise_error
    end
  end

  describe :create_security_group do
    it "should create the security group" do
      check = proc do
        Providers::AWS.fog_client.security_groups.all("group-name" => Providers::AWS::SECURITY_GROUP_NAME)
      end
      expect(check.call).to_not be_present
      Providers::AWS.create_security_group
      expect(check.call).to be_present
    end
  end
end
