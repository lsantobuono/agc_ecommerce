FactoryGirl.define do
  factory :stock_location, class: Spree::StockLocation do
    name { Faker::Lorem.sentence }
    backorderable_default true
  end
end
