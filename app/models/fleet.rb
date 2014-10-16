require 'fog'
require 'providers'

class Fleet < ActiveRecord::Base
  attr_readonly :instance_count, :instance_type

  has_many :instances, :dependent => :destroy

  validates :instance_type, presence: true, inclusion: {
    in: Providers::AWS.flavors,
    message: "must be a valid AWS instance size",
  }
  validates :instance_count, presence: true, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 100,
    message: "must be between 1 and 100",
  }
  validates :provider_region, presence: true, inclusion: {
    in: Providers::AWS.regions,
    message: "must be a valid AWS region",
  }

  after_create :enqueue_create_instances

  def enqueue_create_instances
    CreateInstancesJob.perform_later(self)
  end
end
