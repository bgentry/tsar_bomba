class Run < ActiveRecord::Base
  include Workflow

  belongs_to :fleet
  has_many :results, :dependent => :destroy

  validates :fleet, presence: true, on: :create
  validates :state, presence: true
  validates :target, presence: true
  validates :duration, presence: true, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 1800,
    message: "must be between 1 and 1800",
  }
  validates :rate, presence: true, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 20000,
    message: "must be between 1 and 20000",
  }

  workflow_column :state
  workflow do
    state :initiated do
      event :start, :transitions_to => :started
    end
    state :started do
      event :fail, :transitions_to => :failed
      event :finish, :transitions_to => :finished
    end
    state :failed
    state :finished
  end
end
