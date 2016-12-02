FactoryGirl.define do
  factory :role, class: Spree::Role do
    name { Faker::Lorem.word }
  end
end
