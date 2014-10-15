require 'fog'

module Providers
  module AWS
    extend self

    # Only use 64-bit instances with ephemeral instance storage
    FLAVORS = Fog::Compute[:aws].flavors.select do |f|
      f.bits == 64 && f.instance_store_volumes > 0
    end.map(&:id)

    NON_HVM_FLAVORS = %w{
      t1.micro m1.small m1.medium m1.large m1.xlarge c1.medium c1.xlarge
      m2.xlarge m2.2xlarge m2.4xlarge
    }
    HVM_FLAVORS = FLAVORS - NON_HVM_FLAVORS

    REGIONS = %w{
      us-east-1 us-west-1 us-west-2 eu-west-1 ap-southeast-1 ap-southeast-2
      ap-northeast-1 sa-east-1
    }

    # Ubuntu 14.04 instance-store AMIs
    INSTANCE_STORE_AMIS = {
      "ap-northeast-1" => "ami-69745f68",
      "ap-southeast-1" => "ami-d4183f86",
      "ap-southeast-2" => "ami-3511730f",
      "cn-north-1"     => "ami-4042d079",
      "eu-west-1"      => "ami-ceab0bb9",
      "sa-east-1"      => "ami-afd366b2",
      "us-east-1"      => "ami-52a3153a",
      "us-west-1"      => "ami-5f68631a",
      "us-west-2"      => "ami-df4d0fef",
    }

    SECURITY_GROUP_NAME = "tsar_bomba"

    def flavors
      HVM_FLAVORS
    end

    def images
      INSTANCE_STORE_AMIS
    end

    def regions
      REGIONS
    end

    def bootstrap!
      # TODO: key pair creation (and save in DB)
      group = fog_client.security_groups.all("group-name" => SECURITY_GROUP_NAME).first
      if group.present?
        Rails.logger.debug("security group #{SECURITY_GROUP_NAME} exists")
      else
        Rails.logger.debug("creating security group #{SECURITY_GROUP_NAME}")
        group = create_security_group
      end

      Rails.logger.debug("authorizing SSH access to security group #{SECURITY_GROUP_NAME}")
      authorize_security_group
      # TODO: toggle Flipper feature to indicate successful bootstrap
    end

    def create_security_group
      group = fog_client.security_groups.new({
        name: SECURITY_GROUP_NAME,
        description: "Tsar Bomba load testing security group",
      })
      group.save
      group
    end

    def authorize_security_group
      fog_client.authorize_security_group_ingress(SECURITY_GROUP_NAME, {
        'CidrIp' => '0.0.0.0/0',
        'FromPort' => 22,
        'ToPort' => 22,
        'IpProtocol' => 'tcp',
      })
    rescue Fog::Compute::AWS::Error => e
      unless e.message =~ /InvalidPermission\.Duplicate/
        raise e
      end
    end

    def fog_client
      @fog_client ||= Fog::Compute::AWS.new({
        :aws_access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
        :region => 'us-east-1',
      })
    end
  end
end
