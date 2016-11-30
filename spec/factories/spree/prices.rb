FactoryGirl.define do
  factory :price, class: Spree::Price do
    amount { Faker::Commerce.price }
  end
end
