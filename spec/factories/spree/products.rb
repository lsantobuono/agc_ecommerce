FactoryGirl.define do
  factory :product, class: Spree::Product do
    name { Faker::Lorem.sentence }
    shipping_category
    master { create :variant, is_master: true }
  end
end
