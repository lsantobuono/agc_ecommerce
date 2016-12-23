FactoryGirl.define do
  factory :variant, class: Spree::Variant do
    is_master true
    default_price { build :price }
    track_inventory false
  end
end
