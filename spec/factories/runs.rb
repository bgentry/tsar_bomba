FactoryGirl.define do
  factory :run do
    association :fleet
    target "example.com"
    host_header "sub.example.com"
    duration 90
    rate 200

    notes "extra special notes"
  end
end
