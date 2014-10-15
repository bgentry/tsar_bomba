# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ssh_key_pair do
    private_key "MyText"
  end
end
