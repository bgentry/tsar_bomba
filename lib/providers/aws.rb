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

    def flavors
      HVM_FLAVORS
    end

    def images
      INSTANCE_STORE_AMIS
    end

    def regions
      REGIONS
    end

  end
end
