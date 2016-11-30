FactoryGirl.define do
  factory :line_item, class: Spree::LineItem do
    # variant
    variant { (create :product).master.reload }
    # price 3
  end
end
