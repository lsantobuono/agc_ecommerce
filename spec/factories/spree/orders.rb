FactoryGirl.define do
  factory :order, class: Spree::Order do
    trait :with_line_items do
      line_items { build_list :line_item, 4 }
    end
  end
end
