class Instance < ActiveRecord::Base
  include Workflow

  belongs_to :fleet

  workflow_column :state
  workflow do
    state :awaiting_launch do
      event :launch, :transitions_to => :launched
    end
    state :launched do
      event :running, :transitions_to => :running
    end
    state :running do
      event :bootstrap, :transitions_to => :ready
    end
    state :ready
  end
end
