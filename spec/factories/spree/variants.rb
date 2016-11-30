FactoryGirl.define do
  factory :variant, class: Spree::Variant do
    is_master false
    default_price { build :price }
  end
end
