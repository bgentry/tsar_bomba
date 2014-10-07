require 'rails_helper'

RSpec.describe Fleet, :type => :model do
  it { should have_readonly_attribute(:instance_count) }
  it { should have_readonly_attribute(:instance_type) }


  it { should validate_presence_of(:instance_type) }

  it do
    should validate_inclusion_of(:instance_type).
      in_array(Providers::AWS.flavors).
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
      in_array(Providers::AWS.regions).
      with_message("THIS SHOULD BE BROKEN")
  end
end
