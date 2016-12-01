FactoryGirl.define do
  factory :line_item, class: Spree::LineItem do
    variant { (create :product).master.reload }
    quantity { rand(1..5) }
  end
end
