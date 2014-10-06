require 'fog'

class Fleet < ActiveRecord::Base
  include ActiveModel::Validations

  has_many :instances, :dependent => :destroy

  AMAZON_FLAVORS = Fog::Compute[:aws].flavors.map(&:id)

  validates :instance_type, presence: true, inclusion: {
    in: AMAZON_FLAVORS,
    message: "must be a valid AWS instance size",
  }
  validates :instance_count, presence: true, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 100,
    message: "must be between 1 and 100",
  }
end
