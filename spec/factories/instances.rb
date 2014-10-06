FactoryGirl.define do
  factory :instance do
    fleet

    provider_id { "i-#{SecureRandom.hex(4)}" }
  end
end
