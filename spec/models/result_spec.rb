require 'rails_helper'

RSpec.describe Result, :type => :model do
  it { should belong_to :run }

  it { should belong_to :instance }

  it { should validate_presence_of(:instance).on(:create) }

  it { should validate_presence_of(:raw_data) }
end
