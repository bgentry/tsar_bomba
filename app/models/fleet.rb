require 'fog'

class Fleet < ActiveRecord::Base
  include ActiveModel::Validations

  attr_readonly :instance_count, :instance_type

  has_many :instances, :dependent => :destroy

  AMAZON_FLAVORS = Fog::Compute[:aws].flavors.map(&:id)
  AMAZON_REGIONS = %w{us-east-1 us-west-1 us-west-2 eu-west-1 ap-southeast-1
    ap-southeast-2 ap-northeast-1 sa-east-1}

  validates :instance_type, presence: true, inclusion: {
    in: AMAZON_FLAVORS,
    message: "must be a valid AWS instance size",
  }
  validates :instance_count, presence: true, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 100,
    message: "must be between 1 and 100",
  }
  validates :provider_region, presence: true, inclusion: {
    in: AMAZON_REGIONS,
    message: "must be a valid AWS region",
  }
end
