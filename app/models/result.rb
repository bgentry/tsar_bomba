class Result < ActiveRecord::Base
  belongs_to :run
  belongs_to :instance

  validates :instance, presence: true, on: :create
  validates :raw_data, presence: true
end
