FactoryGirl.define do
  factory :shipping_category, class: Spree::ShippingCategory do
    name { Faker::Lorem.sentence }
  end
end
