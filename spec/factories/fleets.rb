FactoryGirl.define do
  factory :fleet do
    instance_count  2
    instance_type   "m3.large"
    provider_region "us-east-1"
  end
end
