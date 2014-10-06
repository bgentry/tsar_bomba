require 'rails_helper'

RSpec.describe Fleet, :type => :model do
  it { should have_readonly_attribute(:instance_count) }
  it { should have_readonly_attribute(:instance_type) }

  it { should have_many(:instances) }

  it "should have AMAZON_FLAVORS set to the correct array" do
    expect(Fleet.constants).to include(:AMAZON_FLAVORS)
    expect(Fleet::AMAZON_FLAVORS).to be_a(Array)
    expect(Fleet::AMAZON_FLAVORS).to include("m3.large")
    expect(Fleet::AMAZON_FLAVORS).to eq(Fog::Compute[:aws].flavors.map(&:id))
  end

  it "should have AMAZON_REGIONS set to the correct array" do
    expect(Fleet.constants).to include(:AMAZON_REGIONS)
    expect(Fleet::AMAZON_REGIONS).to be_a(Array)
    expect(Fleet::AMAZON_REGIONS).to eq(%w{
      us-east-1 us-west-1 us-west-2 eu-west-1 ap-southeast-1
      ap-southeast-2 ap-northeast-1 sa-east-1
    })
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

  it do
    should validate_inclusion_of(:provider_region).
      in_array(Fleet::AMAZON_FLAVORS).
      with_message("THIS SHOULD BE BROKEN")
  end
end
