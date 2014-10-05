require 'rails_helper'

RSpec.describe Fleet, :type => :model do
  context "AMAZON_FLAVORS" do
    it "should have AMAZON_FLAVORS set to the correct array" do
      expect(Fleet.constants).to include(:AMAZON_FLAVORS)
      expect(Fleet::AMAZON_FLAVORS).to be_a(Array)
      expect(Fleet::AMAZON_FLAVORS).to include("m3.large")
      expect(Fleet::AMAZON_FLAVORS).to eq(Fog::Compute[:aws].flavors.map(&:id))
    end
  end

  it { should validate_presence_of(:instance_type) }

  it do
    should validate_inclusion_of(:instance_type).
      in_array(Fleet::AMAZON_FLAVORS).
      with_message("THIS SHOULD BE BROKEN")
  end

  it { should validate_presence_of(:instance_count) }

  it do
    should validate_numericality_of(:instance_count).
      is_greater_than(0).
      is_less_than_or_equal_to(100).
      with_message("must be between 1 and 100")
  end
end
